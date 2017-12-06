# frozen_string_literal: true

module YamlEnvTag
  # The base exception class for YamlEnvTag.
  class Error < ::RuntimeError; end

  # Exception raised when the +!ENV+ tag is used on a wrong node type
  # or on empty node.
  class InvalidUsageError < Error; end

  # Exception raised when environment variable specified by the +!ENV+ tag
  # is not set.
  class MissingEnvVariableError < Error

    attr_reader :variable_name

    # @param variable_name [String] name of the environment variable.
    def initialize(variable_name)
      @variable_name = variable_name
      super("Environment variable '#{variable_name}' is not set")
    end
  end
end
