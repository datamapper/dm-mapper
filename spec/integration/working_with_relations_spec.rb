# encoding: utf-8

require 'spec_helper'

describe 'Working with relations' do
  let(:header) {
    Axiom::Relation::Header.coerce([[:id, Integer], [:name, String]])
  }

  let(:mapper) {
    TestMapper.new(header, model)
  }

  let(:model) {
    Class.new(OpenStruct)
  }

  specify 'relation setup' do
    env  = ROM::Environment.coerce(test: 'memory://test')
    repo = env.repository(:test)

    repo[:users] = Axiom::Relation::Base.new(:users, header)

    users = ROM::Relation.new(repo[:users], mapper)

    user = model.new(id: 1, name: 'Jane')
    users.insert(user)

    expect(users.to_a).to include(user)
  end
end
