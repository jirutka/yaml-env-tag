# frozen_string_literal: true
require 'yaml_env_tag/errors'

module YamlEnvTag
  # A specialized String that holds a value of environment variable specified
  # by +!ENV+ tag.
  class EnvVariable < String

    # Deserializes from YAML. This method is called by {Psych}.
    #
    # @param coder [Psych::Coder] coder with +:scalar+ or +:seq+.
    # @raise MissingEnvVariableError if the specified environment variable
    #   is not set (i.e. does not exist in +ENV+).
    def init_with(coder)
      *variables, default =
        case coder.type
        when :scalar
          [coder.scalar, nil]
        when :seq
          coder.seq.size < 2 ? [*coder.seq, nil] : coder.seq
        else
          raise InvalidUsageError, "#{coder.tag} tag cannot be used on a #{coder.type} node"
        end

      initialize(variables, default)
    end

    protected

    # @param variables [Array<String>] names of the environment variables;
    #   value of the first variable that does exist will be used.
    # @param default_value [String, nil] the default value to use when none of
    #   the _variables_ exist.
    def initialize(variables, default_value)
      value = variables.lazy.map { |n| ::ENV[n] if n }.find(&:itself)
      value ||= default_value

      raise MissingEnvVariableError, variables.last if value.nil?
      super(value.to_s)
    end
  end
end
