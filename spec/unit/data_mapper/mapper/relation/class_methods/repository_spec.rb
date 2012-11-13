require 'spec_helper'

describe Mapper::Relation, '.repository' do
  let(:name) { :postgres }

  context "with a name" do
    it "sets the repository name" do
      described_class.repository(name)
      described_class.repository.should be(name)
    end
  end
end
