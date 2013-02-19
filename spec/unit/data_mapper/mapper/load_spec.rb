require 'spec_helper'

describe Mapper, '#load' do
  subject { object.load(tuple) }

  let(:object) { mapper.new }

  let(:mapper) { Class.new(described_class) { map :name, String, :to => :username } }
  let(:tuple)  { { :username => name } }
  let(:model)  { mock_model('User') }
  let(:name)   { 'Piotr' }

  before { mapper.model(model) }

  it { should be_instance_of(model) }

  its(:name) { should eql(name) }
end
