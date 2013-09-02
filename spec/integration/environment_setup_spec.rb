# encoding: utf-8

require 'spec_helper'

describe 'Setting up environment' do
  it 'registers relations within repositories' do
    env = ROM::Environment.setup(memory: 'memory://test')

    schema = env.schema do
      base_relation :users do
        repository :memory

        attribute :id,   Integer
        attribute :name, String

        key :id
      end
    end

    expect(schema[:users]).to be_instance_of(Axiom::Relation::Variable::Materialized)
  end
end
