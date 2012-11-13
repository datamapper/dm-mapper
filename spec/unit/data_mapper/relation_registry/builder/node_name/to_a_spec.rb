require 'spec_helper'

describe RelationRegistry::Builder::NodeName, '#to_a' do
  subject { object.to_a }

  let(:object) { described_class.new(left, right, relationship) }
  let(:left)   { :foo }
  let(:right)  { :bar }

  context 'with no relationship given' do
    let(:relationship) { nil }

    it { should == [ left, right ] }
  end

  context 'with a given relationship' do
    let(:relationship) { mock('relationship', :name => name, :operation => operation) }
    let(:name)         { :funky_bar }

    context 'with no operation' do
      let(:operation) { nil }

      it { should == [ left, right ] }
    end

    context 'with an operation' do
      let(:operation) { Proc.new {} }

      it { should == [ left, name ] }
    end
  end
end
