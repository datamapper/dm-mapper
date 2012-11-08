module DataMapper
  class RelationRegistry

    # Builds relation nodes for relationships
    #
    # @abstract
    #
    # @api private
    class Builder

      include AbstractClass

      # The {RelationRegistry} used by this builder
      #
      # @return [RelationRegistry]
      #
      # @api private
      attr_reader :relations

      # The {MapperRegistry} used by this builder
      #
      # @return [MapperRegistry]
      #
      # @api private
      attr_reader :mappers

      # The relationship to build the {RelationNode} and {Connector} for
      #
      # @see RelationNode
      # @see Connector
      #
      # @return [Relationship]
      #
      # @api private
      attr_reader :relationship

      # The {Connector} built for {#relationship}
      #
      # @return [Connector]
      #
      # @api private
      attr_reader :connector

      # Build a new {RelationNode} and {Connector} for +relationship+
      #
      # @param [RelationRegistry] relations
      #   a registry of relations
      #
      # @param [MapperRegistry] mappers
      #   a registry of mappers
      #
      # @param [Relationship] relationship
      #   the relationship the connector is built for
      #
      # @return [BaseBuilder, ViaBuilder]
      #
      # @api private
      def self.call(relations, mappers, relationship)
        klass = relationship.via ? ViaBuilder : BaseBuilder
        klass.new(relations, mappers, relationship)
      end

      # Initialize a new {Builder} instance
      #
      # @param [RelationRegistry] relations
      #   the registry of relations
      #
      # @param [MapperRegistry] mappers
      #   the registry of mappers
      #
      # @param [Relationship] relationship
      #   the relationship the connector is built for
      #
      # @return [undefined]
      #
      # @api private
      def initialize(relations, mappers, relationship)
        @relations, @mappers, @relationship = relations, mappers, relationship
        initialize_nodes

        edge     = build_edge
        relation = build_relation(edge)
        node     = build_node(name, relation)

        @connector = RelationRegistry::Connector.new(name, node, relationship, relations)
        relations.add_connector(@connector)
      end

      # The relationship's source model relation name
      #
      # @return [Symbol]
      #
      # @api private
      def left_name
        mappers[relationship.source_model].class.relation_name
      end

      # The relationship's target model relation name
      #
      # @return [Symbol]
      #
      # @api private
      def right_name
        mappers[relationship.target_model].class.relation_name
      end

      # The relationship's source relation node
      #
      # @return [RelationNode]
      #
      # @api private
      def left_node
        relations[left_name]
      end

      # The relationship's target relation node
      #
      # @return [RelationNode]
      #
      # @api private
      def right_node
        relations[right_name]
      end

      private

      # @api private
      def initialize_nodes
        # no-op
      end

      # @api private
      def build_relation(edge, relationship = relationship)
        relation = edge.relation(relationship)
        relation = relation.instance_eval(&relationship.operation) if relationship.operation
        relation
      end

      # @api private
      def build_node(name, relation)
        unless relations[name]
          node = relations.build_node(name, relation)
          relations.add_node(node)
        end

        relations[name]
      end

      # @api private
      def build_edge(name = relationship.name, left = left_node, right = right_node)
        edge = relations.edge_for(left, right)

        unless edge
          edge = relations.build_edge(name, left, right)
          relations.add_edge(edge)
        end

        edge
      end

    end # class Builder

  end # class RelationRegistry
end # module DataMapper
