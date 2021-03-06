# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seraph/grape/version'
require 'English'

Gem::Specification.new do |gem|
  gem.name          = 'seraph-grape'
  gem.version       = Seraph::Grape::VERSION
  gem.summary       = 'Seraph helpers for Grape'
  gem.description   = 'Integrate Seraph with your Grape API'
  gem.license       = 'MIT'
  gem.authors       = ['Szymon Szeliga']
  gem.email         = 'szeliga.szymon@gmail.com'
  gem.homepage      = 'https://rubygems.org/gems/seraph-grape'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  `git submodule --quiet foreach --recursive pwd`.split($INPUT_RECORD_SEPARATOR).each do |submodule|
    submodule.sub!("#{Dir.pwd}/", '')

    Dir.chdir(submodule) do
      `git ls-files`.split($INPUT_RECORD_SEPARATOR).map do |subpath|
        gem.files << File.join(submodule, subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'grape', '~> 0.16'
  gem.add_runtime_dependency 'seraph', '~> 0.1'
  gem.add_runtime_dependency 'jwt', '~> 1.5'
  gem.add_development_dependency 'rake', '~> 11.2'
  gem.add_development_dependency 'rack-test', '~> 0.6'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'fuubar', '~> 2.0'
  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.1'
end
