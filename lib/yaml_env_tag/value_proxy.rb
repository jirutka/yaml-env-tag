# frozen_string_literal: true
require 'delegate'
require 'yaml_env_tag/errors'

module YamlEnvTag
  # A value proxy for the +!ENV+ tag that "deserializes" the tag, i.e. reads
  # the specified environment variable and holds its value.
  class ValueProxy < ::SimpleDelegator

    # Deserializes from YAML. This method is called by {Psych}.
    #
    # @param coder [Psych::Coder, #scalar]
    # @raise MissingEnvVariableError if the specified environment variable
    #   is not set (i.e. does not exist in +ENV+).
    def init_with(coder)
      var_name = coder.scalar
      value = ::ENV[var_name] or raise MissingEnvVariableError, var_name
      initialize(value)
    end
  end
end
