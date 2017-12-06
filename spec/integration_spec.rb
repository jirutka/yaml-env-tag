require_relative 'spec_helper'
require 'yaml-env-tag'

describe '!ENV tag' do

  context 'on scalar' do
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
        }.to raise_error YamlEnvTag::MissingEnvVariableError
      end
    end
  end

  context 'on seq' do
    error = YamlEnvTag::MissingEnvVariableError
    ENV['EXISTS'] = 'first'
    ENV['EXISTS2'] = 'second'
    ENV['MISS'] = nil
    ENV['MISS2'] = nil

    [#| input                              | expected      |#
      [ '!ENV [EXISTS]'                    , ENV['EXISTS'] ],
      [ '!ENV [MISS]'                      , error         ],
      [ '!ENV [EXISTS, ~]'                 , ENV['EXISTS'] ],
      [ '!ENV [MISS, ~]'                   , error         ],
      [ '!ENV [EXISTS, "default"]'         , ENV['EXISTS'] ],
      [ '!ENV [MISS, "default"]'           , 'default'     ],
      [ '!ENV [EXISTS, EXISTS2, ~]'        , ENV['EXISTS'] ],
      [ '!ENV [MISS, EXISTS, ~]'           , ENV['EXISTS'] ],
      [ '!ENV [EXISTS, MISS, ~]'           , ENV['EXISTS'] ],
      [ '!ENV [MISS, MISS2, ~]'            , error         ],
      [ '!ENV [EXISTS, EXISTS2, "default"]', ENV['EXISTS'] ],
      [ '!ENV [EXISTS, MISS, "default"]'   , ENV['EXISTS'] ],
      [ '!ENV [MISS, EXISTS, "default"]'   , ENV['EXISTS'] ],
      [ '!ENV [MISS, MISS2, "default"]'    , 'default'     ],
    ].each do |input, expected|
      context input do
        subject { YAML.load(input) }

        if expected == error
          it 'raises MissingEnvVariableError' do
            expect { subject }.to raise_error YamlEnvTag::MissingEnvVariableError
          end
        elsif expected == 'default'
          it 'results in the default value' do
            is_expected.to eq expected
          end
        else
          it 'results in value of the variable EXISTS' do
            is_expected.to eq expected
          end
        end
      end
    end

    context 'empty' do
      it 'raises MissingEnvVariableError' do
        expect {
          YAML.load('!ENV []')
        }.to raise_error YamlEnvTag::MissingEnvVariableError
      end
    end
  end

  context 'on map' do
    it 'raises InvalidUsageError' do
      expect {
        YAML.load('!ENV { foo: 42 }')
      }.to raise_error YamlEnvTag::InvalidUsageError
    end
  end

  context 'on empty node' do
    it 'raises MissingEnvVariableError' do
      expect {
        YAML.load('!ENV ')
      }.to raise_error YamlEnvTag::MissingEnvVariableError
    end
  end
end
