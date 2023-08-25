# frozen_string_literal: true

require 'json'
require 'pastel'

require_relative '../../meme'

class Meme
  module App
    module Templates
      class << self
        def list
          cache_create if !cached?

          cache_read
        end

        private

        def cached?
          return false if !File.exist?(cache_file)
          return false if File.mtime(cache_file) < Time.now - (60 * 50 * 2)

          true
        end

        def cache_create
          File.write(cache_file, JSON.generate(Meme.templates))
          File.chmod(0o600, cache_file)
        rescue StandardError => e
          bailout(e)
        end

        def cache_read
          JSON.parse(File.read(cache_file))
        rescue StandardError => e
          bailout(e)
        end

        def cache_file
          File.join(ENV.fetch('XDG_RUNTIME_DIR', '/tmp'), ".#{ENV.fetch('USER')}_memes")
        end

        def bailout(error)
          puts Pastel.new.red.bold(error.cause || error.message)
          exit(1)
        end
      end
    end
  end
end
