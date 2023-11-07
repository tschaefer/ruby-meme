# frozen_string_literal: true

require_relative 'app/create'
require_relative 'app/generate'
require_relative 'app/templates'

class Meme
  # :nodoc: all
  module App
    Clamp.allow_options_after_parameters = true

    class Command < Clamp::Command
      option ['-m', '--man'], :flag, 'show manpage' do
        manpage = <<~MANPAGE
          Name:
              meme - create and generate memes

          #{help}
          Description:
              meme is a command line tool to create and generate memes.

              By providing a template name and captions, meme will create a meme with that information.
              The available templates can be listed with the --list option.

              By providing a phrase, meme will generate a suitabble meme.

              The result is the url to the meme image.

          Examples:
              $ meme afraid "I don't know what this meme is for" "And at this point I'm too afraid to ask"
              $ meme "I don't always generate memes. But when I do, I use meme"
              $ meme sad-biden --example

          Authors:
              Tobias Schäfer <github@blackox.org>

          Copyright and License
              This software is copyright (c) 2023 by Tobias Schäfer.

              This package is free software; you can redistribute it and/or modify it under the terms of the "MIT License".
        MANPAGE
        TTY::Pager.page(manpage)
        exit(0)
      end

      option ['-v', '--version'], :flag, 'show version' do
        puts "meme #{Meme::VERSION}"
        exit(0)
      end

      option ['-l', '--list'], :flag, 'list templates' do
        Meme::App::Templates.list.each do |template|
          puts "#{template['id']}: #{template['name']}"
        end
        exit(0)
      end

      Meme::App::Templates.list.each do |template|
        klass = "Create#{template['id'].gsub('-', '').capitalize}Command"

        Object.const_set(
          klass,
          Class.new(Meme::App::Create) do
            parameter 'CAPTION ...', 'the captions to use.', attribute_name: :caption

            self.template = template
          end
        )

        subcommand template['id'], template['name'], Object.const_get(klass)
      end

      def subcommand_missing(_)
        Meme::App::GenerateCommand.run
        exit(0)
      end
    end
  end
end
