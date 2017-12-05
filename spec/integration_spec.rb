require_relative 'spec_helper'

module YamlEnvTag
  describe '!ENV tag' do

    context 'with existing variable' do
      before { ENV['SOME_VARIABLE'] = var_value }

      [
        ['allons-y!', 'that is not empty'],
        [''         , 'that is empty'    ],
      ].each do |value, desc|
        context desc do
          let(:var_value) { value }
          subject { YAML.load('!ENV SOME_VARIABLE') }

          it 'results in value of the variable' do
            is_expected.to eq var_value
          end

          it 'deserialized value is kind of String' do
            is_expected.to be_kind_of String
          end
        end
      end
    end

    context 'with non-existing variable' do
      before { ENV['NON_EXISTING'] = nil }

      it 'raises MissingEnvVariableError' do
        expect {
          YAML.load('!ENV NON_EXISTING')
        }.to raise_error MissingEnvVariableError
      end
    end
  end
end
