require 'spec_helper'

describe Mapper::Attribute, '#initialize' do
  subject { object.new(name, options) }

  let(:name)    { :id }
  let(:options) { {}  }

  it_should_behave_like 'an abstract class'
end
