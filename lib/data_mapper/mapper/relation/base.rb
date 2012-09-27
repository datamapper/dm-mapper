module DataMapper
  class Mapper
    class Relation

      class Base < self

        def self.from(other)
          klass = super
          klass.relation_name(other.relation_name)
          klass
        end

        # Set or return the name of this mapper's default relation
        #
        # @api public
        def self.relation_name(name = Undefined)
          if name.equal?(Undefined)
            @relation_name
          else
            @relation_name = name
          end
        end

        # @api public
        def self.relation
          @relation ||= Veritas::Relation::Base.new(
            relation_name, attributes.header
          )
        end

        def self.finalize
          gateway_relation = Mapper.register_relation(repository, relation)
          Mapper.mapper_registry << new(gateway_relation)
        end

        def self.key(names)
          Array(names).each do |name|
            attributes << attributes[name].clone(:key => true)
          end
        end
      end # class Base
    end # class Relation
  end # class Mapper
end # module DataMapper
