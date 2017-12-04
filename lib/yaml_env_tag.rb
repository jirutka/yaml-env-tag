# frozen_string_literal: true
require 'yaml_env_tag/version'
require 'yaml_env_tag/errors'
require 'yaml_env_tag/value_proxy'
require 'yaml'

YAML.add_tag '!ENV', YamlEnvTag::ValueProxy
