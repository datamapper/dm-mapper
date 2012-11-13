module DataMapper
  class Relationship
    class OneToMany < self

      module Iterator

        # Iterate over the loaded domain objects
        #
        # TODO: refactor this and add support for multi-include
        #
        # @see Mapper::Relation#each
        #
        # @example
        #
        #   DataMapper[Person].include(:tasks).each do |person|
        #     person.tasks.each do |task|
        #       puts task.name
        #     end
        #   end
        #
        # @yield [object] the loaded domain objects
        #
        # @yieldparam [Object] object
        #   the loaded domain object that is yielded
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?

          tuples     = relation.to_a
          parent_key = attributes.key
          name       = attributes.detect { |attribute|
            attribute.kind_of?(Mapper::Attribute::EmbeddedCollection)
          }.name

          parents = tuples.each_with_object({}) do |tuple, hash|
            key = parent_key.map { |attribute| tuple[attribute.field] }
            hash[key] = attributes.primitives.each_with_object({}) { |attribute, parent|
              parent[attribute.field] = tuple[attribute.field]
            }
          end

          parents.each do |key, parent|
            parent[name] = tuples.map { |tuple|
              current_key = parent_key.map { |attribute| tuple[attribute.field] }
              if key == current_key
                tuple
              end
            }
            parent[name].compact!
          end

          parents.each_value { |parent| yield(load(parent)) }

          self
        end

      end # module Iterator

    end # class OneToMany
  end # class Relationship
end # module DataMapper
