require 'spec_helper'

describe Graph::Node, '#replace' do
  subject { object.replace(tuples) }

  let(:object)         { Graph::Node.new(name, relation) }
  let(:name)           { :users }
  let(:relation)       { mock_relation('users', header, initial_tuples) }
  let(:header)         { [ [ :id, Integer ] ] }
  let(:initial_tuples) { [ [ 1 ], [ 2 ] ] }
  let(:tuples)         { [ [ 2 ] ] }

  let(:expected_object)   { Graph::Node.new(name, expected_relation) }
  let(:expected_relation) { relation.replace(tuples) }

  it { should eq(expected_object) }
end
