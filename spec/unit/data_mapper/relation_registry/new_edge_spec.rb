require 'spec_helper'

describe RelationRegistry, '#new_edge' do
  subject { object.new_edge(name, left, right, join_key_map) }

  let(:object) { described_class.new(TEST_ENGINE) }

  let(:name)         { 'users' }
  let(:left)         { mock('left') }
  let(:right)        { mock('right') }
  let(:join_key_map) { mock('join_key_map') }

  it { should be(object) }

  it "adds a new edge" do
    subject.edge_for(left, right).should be_instance_of(TEST_ENGINE.relation_edge_class)
  end
end
