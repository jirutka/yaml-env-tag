# frozen_string_literal: true

module YamlEnvTag
  # An error class raised when environment variable specified by the `!ENV` tag
  # is not set.
  class MissingEnvVariableError < ::RuntimeError

    # @param variable_name [String] name of the environment variable.
    def initialize(variable_name)
      super("Environment variable '#{variable_name}' is not set")
    end
  end
end
