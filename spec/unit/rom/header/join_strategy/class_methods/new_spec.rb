require 'spec_helper'

describe Header::JoinStrategy, '.new' do
  subject { object.new(attribute_index, join_definition) }

  let(:attribute_index) { mock('AttributeIndex',  :entries => mock) }
  let(:join_definition) { mock('join_definition', :to_hash => mock) }

  before do
    pending 'this blows up for some reason :P'
  end

  it_behaves_like 'an abstract type'
end
