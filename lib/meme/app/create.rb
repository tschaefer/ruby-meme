# frozen_string_literal: true

require_relative 'base'
require_relative '../../meme'

class Meme
  module App
    class Create < Meme::App::BaseCommand
      class << self
        attr_accessor :template
      end

      parameter 'PHRASE', 'the phrase to use.'

      option ['-e', '--example'], :flag, 'show example' do
        puts self.class.template['example']['url']
        exit(0)
      end

      def execute
        exec do
          meme = Meme.new(template: self.class.template['id'], caption: phrase)
          meme.animated = animated?
          url = meme.create
          url = tinyurl(url)

          puts url
        end
      end
    end
  end
end
