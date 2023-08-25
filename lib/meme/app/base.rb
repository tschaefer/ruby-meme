# frozen_string_literal: true

require 'httparty'

require 'clamp'
require 'pastel'
require 'tty-pager'

require_relative '../version'

class Meme
  module App
    class BaseCommand < Clamp::Command
      option ['-a', '--animated'], :flag, 'animated gif',
             default: false

      option ['-s', '--shorten'], :flag, 'shorten url', default: false

      private

      def exec
        yield
      rescue StandardError => e
        bailout(e)
      end

      def bailout(error)
        puts Pastel.new.red.bold(error.cause || error.message)
        exit(1)
      end

      def tinyurl(url)
        return url if !shorten?

        response = nil
        begin
          response = HTTParty.get("http://tinyurl.com/api-create.php?url=#{url}")
        rescue StandardError
          # noop
        end
        return url if response.body.nil? || !response.success?

        response.body
      end
    end
  end
end
