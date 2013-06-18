require 'spec_helper'

describe 'Defining a ROM schema' do
  let(:people)              { Axiom::Relation::Base.new(:people, people_header) }
  let(:people_header)       { Axiom::Relation::Header.coerce(people_attributes, :keys => people_keys) }
  let(:people_attributes)   { [ [ :id, Integer ], [ :name, String ] ] }
  let(:people_keys)         { [ :id ] }

  let(:profiles)            { Axiom::Relation::Base.new(:profiles, profiles_header) }
  let(:profiles_header)     { Axiom::Relation::Header.coerce(profiles_attributes, :keys => profiles_keys) }
  let(:profiles_attributes) { [ [ :id, Integer ], [ :person_id, Integer ], [ :text, String ] ] }
  let(:profiles_keys)       { [ :id, :person_id ] }

  let(:people_with_profile) { people.join(profiles.rename(:id => :profile_id, :person_id => :id)) }

  let(:schema) do
    ROM::Schema.build do
      base_relation :people do
        repository :postgres

        attribute :id,   Integer
        attribute :name, String

        key :id
      end

      base_relation :profiles do
        repository :postgres

        attribute :id,        Integer
        attribute :person_id, Integer
        attribute :text,      String

        key :id
        key :person_id
      end

      relation :people_with_profile do
        people.join(profiles.rename(:id => :profile_id, :person_id => :id))
      end
    end
  end

  it 'registers the people relation' do
    expect(schema[:people]).to eql(people)
  end

  it 'establishes key attributes for people relation' do
    expect(schema[:people].header.keys.flat_map { |h| h.map(&:name) }).to eq(people_keys)
  end

  it 'establishes key attributes for profiles relation' do
    expect(schema[:profiles].header.keys.flat_map { |h| h.map(&:name) }).to eq(profiles_keys)
  end

  it 'registers the profiles relation' do
    expect(schema[:profiles]).to eql(profiles)
  end

  it 'registers the people_with_profile relation' do
    expect(schema[:people_with_profile]).to eql(people_with_profile)
  end
end
