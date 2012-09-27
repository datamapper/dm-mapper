require 'spec_helper'

describe DataMapper::Mapper, '.from' do
  subject { described_class.from(other, name) }

  let(:model) {
    mock_model(:TestModel)
  }

  let(:other) {
    model_class = model

    Class.new(described_class) {
      model model_class
      map :id, Integer
    }
  }

  context "with another mapper" do
    context "without a name" do
      let(:name) { nil }

      its(:model) { should be(model) }
      its(:name)  { should eql("TestModelMapper") }
    end

    context "with a name" do
      let(:name) { 'AnotherTestModelMapper' }

      its(:model) { should be(model) }
      its(:name)  { should eql(name) }
    end
  end
end
