require 'spec_helper'

describe AliasSet, '#excluded' do
  subject { object.excluded }

  let(:relation_name) { :songs }

  context 'with no excluded attributes passed to #initialize' do
    let(:object) { described_class.new(relation_name) }

    it { should == [] }
  end

  context 'with excluded attributes passed to #initialize' do
    let(:object)     { described_class.new(relation_name, attributes, excluded) }
    let(:attributes) { Mapper::AttributeSet.new << attribute             }
    let(:attribute)  { Mapper::Attribute.build(:id, :type => Integer)    }
    let(:excluded)   { [ :id ] }

    it { should == excluded }
  end
end
