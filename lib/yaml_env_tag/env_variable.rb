# frozen_string_literal: true
require 'yaml_env_tag/errors'

module YamlEnvTag
  # A specialized String that holds a value of environment variable specified
  # by +!ENV+ tag.
  class EnvVariable < String

    # Deserializes from YAML. This method is called by {Psych}.
    #
    # @param coder [Psych::Coder, #scalar] coder with name of the environment
    #   variable to read.
    # @raise MissingEnvVariableError if the specified environment variable
    #   is not set (i.e. does not exist in +ENV+).
    def init_with(coder)
      var_name = coder.scalar
      value = ::ENV[var_name] or raise MissingEnvVariableError, var_name
      initialize(value)
    end
  end
end
