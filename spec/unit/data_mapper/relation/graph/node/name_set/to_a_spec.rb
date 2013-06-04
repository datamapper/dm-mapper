require 'spec_helper'

describe Relation::Graph::Node::NameSet, '#to_a' do
  subject { object.to_a }

  let(:object) { described_class.new(songs_info_contents, mapper_registry) }

  let(:mapper_registry) {
    mapper_registry = Mapper::Registry.new

    [ song_mapper, song_tag_mapper, tag_mapper, info_mapper, info_content_mapper ].each do |mapper|
      mapper_registry.register(mapper)
    end

    mapper_registry
  }

  let(:song_mapper)                { mock_mapper(song_model, [], song_relationships).new(ROM_ENV, songs_relation) }
  let(:songs_relation)             { mock_relation(:songs) }
  let(:song_relationships)         { [ songs_song_tags, songs_tags, songs_infos, songs_info_contents ] }

  let(:song_tag_mapper)            { mock_mapper(song_tag_model, [], song_tag_relationships).new(ROM_ENV, song_tags_relation) }
  let(:song_tags_relation)         { mock_relation(:song_tags) }
  let(:song_tag_relationships)     { [ song_tags_song, song_tags_tag ] }

  let(:tag_mapper)                 { mock_mapper(tag_model, [], tag_relationships).new(ROM_ENV, tags_relation) }
  let(:tags_relation)              { mock_relation(:tags) }
  let(:tag_relationships)          { [ tags_infos ] }

  let(:info_mapper)                { mock_mapper(info_model, [], info_relationships).new(ROM_ENV, infos_relation) }
  let(:infos_relation)             { mock_relation(:infos) }
  let(:info_relationships)         { [ infos_info_contents ] }

  let(:info_content_mapper)        { mock_mapper(info_content_model, [], info_content_relationships).new(ROM_ENV, info_contents_relation) }
  let(:info_contents_relation)     { mock_relation(:info_contents) }
  let(:info_content_relationships) { [] }

  let(:song_model)          { mock_model('Song') }
  let(:song_tag_model)      { mock_model('SongTag') }
  let(:tag_model)           { mock_model('Tag') }
  let(:info_model)          { mock_model('Info') }
  let(:info_content_model)  { mock_model('InfoContent') }

  let(:songs_song_tags)     { Relationship::OneToMany .new(:song_tags,     song_model,     song_tag_model) }
  let(:songs_tags)          { Relationship::ManyToMany.new(:tags,          song_model,     tag_model,          :through => :song_tags, :via => :tag) }
  let(:songs_infos)         { Relationship::ManyToMany.new(:infos,         song_model,     info_model,         :through => :tags,      :via => :infos) }
  let(:songs_info_contents) { Relationship::ManyToMany.new(:info_contents, song_model,     info_content_model, :through => :infos,     :via => :info_contents) }
  let(:song_tags_song)      { Relationship::ManyToOne .new(:song,          song_tag_model, song_model) }
  let(:song_tags_tag)       { Relationship::ManyToOne .new(:tag,           song_tag_model, song_model) }
  let(:tags_infos)          { Relationship::OneToMany .new(:infos,         tag_model,      info_model) }
  let(:infos_info_contents) { Relationship::OneToMany .new(:info_contents, info_model,     info_content_model) }

  before do
    mapper_registry.each do |_, mapper|
      name       = mapper.relation_name
      repository = ROM_ENV.repository(mapper.class.repository)
      repository.register(name, mapper.attributes.header)

      relation = repository.get(name)
      header   = Relation::Graph::Node.header(name, mapper.attributes.fields)

      ROM_ENV.relations.new_node(name, relation, header)

      mapper.relationships.each { |relationship| relationship.finalize(mapper_registry) }
    end
  end

  it "includes all join nodes in the correct order" do
    subject.map(&:to_sym).should == [
      :songs_X_song_tags,
      :songs_X_song_tags_X_tags,
      :songs_X_song_tags_X_tags_X_infos,
      :songs_X_song_tags_X_tags_X_infos_X_info_contents
    ]
  end
end
