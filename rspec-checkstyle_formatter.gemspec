# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'rspec-checkstyle_formatter'
  spec.version       = '0.1.1'
  spec.authors       = ['astronoka']
  spec.email         = ['skulituniga@gmail.com']

  spec.summary       = 'Outputs the result of rspec as a checkstyle format.'
  spec.description   = 'Outputs the result of rspec as a checkstyle format.'
  spec.homepage      = 'https://github.com/astronoka/rspec-checkstyle_formatter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  # spec.metadata["changelog_uri"]   = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rspec-core', '~> 3.0'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rubocop', '~> 0.93.0'
end
