require 'spec_helper'

describe Graph::Node, '#insert' do
  subject { object.insert(tuples) }

  let(:object)         { Graph::Node.new(name, relation) }
  let(:name)           { :users }
  let(:relation)       { mock_relation('users', header, initial_tuples) }
  let(:header)         { [ [ :id, Integer ] ] }
  let(:initial_tuples) { [ [ 1 ], [ 2 ] ] }
  let(:tuples)         { [ [ 3 ] ] }

  let(:expected_object)   { Graph::Node.new(name, expected_relation) }
  let(:expected_relation) { relation.insert(tuples) }

  it { should eq(expected_object) }
end
