# frozen_string_literal: true

require_relative 'base'

class Meme
  module App
    class GenerateCommand < Meme::App::BaseCommand
      parameter 'PHRASE', 'the phrase to use.'

      def execute
        exec do
          url = Meme.generate(phrase:)
          url = tinyurl(url)

          puts url
        end
      end
    end
  end
end
