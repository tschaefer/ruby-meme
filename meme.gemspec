# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'meme/version'

Gem::Specification.new do |spec|
  spec.name        = 'meme'
  spec.version     = Meme::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Tobias Schäfer']
  spec.email       = ['github@blackox.org']

  spec.summary     = 'Memes, memes everywhere.'
  spec.description = <<~DESC
    #{spec.summary}

    A memegen.link ruby client.
  DESC
  spec.homepage = 'https://github.com/tschaefer/ruby-meme'
  spec.license  = 'MIT'

  spec.files                 = Dir['lib/**/*']
  spec.bindir                = 'bin'
  spec.executables           = ['meme']
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri']       = 'https://github.com/tschaefer/ruby-meme'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/tschaefer/ruby-meme/issues'

  spec.post_install_message = 'All your meme are belong to us!'

  spec.add_dependency 'clamp', '~>1.3.2'
  spec.add_dependency 'httparty', '~>0.21.0'
  spec.add_dependency 'pastel', '~>0.8.0'
  spec.add_dependency 'tty-pager', '~>0.14.0'
  spec.add_dependency 'tty-screen', '~>0.8.1'
end
