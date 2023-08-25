# frozen_string_literal: true

desc 'Build documentation.'
task :doc do
  docs = [
    'meme.rb'
  ].map { |f| "lib/#{f}" }.join(' ')
  system "rdoc #{docs}"
end
