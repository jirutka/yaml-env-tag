require File.expand_path('../lib/yaml_env_tag/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'yaml-env-tag'
  s.version       = YamlEnvTag::VERSION
  s.author        = 'Jakub Jirutka'
  s.email         = 'jakub@jirutka.cz'
  s.homepage      = 'https://github.com/jirutka/yaml-env-tag'
  s.license       = 'MIT'

  s.summary       = 'Custom YAML tag for referring environment variables in YAML files'

  s.files         = Dir['lib/**/*', '*.gemspec', 'LICENSE*', 'README*']

  s.required_ruby_version = '>= 2.0'

  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rubocop', '~> 0.49.0'
  s.add_development_dependency 'simplecov', '~> 0.14'
end
