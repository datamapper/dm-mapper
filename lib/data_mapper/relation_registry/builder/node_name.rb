module DataMapper
  class RelationRegistry
    class Builder

      # Represents a joined relation node name
      #
      class NodeName
        # Separator used to split left/right sides
        SEPARATOR = '_X_'.freeze

        # @api private
        attr_reader :left

        # @api private
        attr_reader :right

        # @api private
        attr_reader :relationship

        # Initialize a node name
        #
        # @return [undefined]
        #
        # @api private
        def initialize(*args)
          @left, @right = args[0..1]
          @relationship = args.last if args.size == 3

          unless @left && @right
            raise ArgumentError, "+left+ and +right+ must be defined"
          end
        end

        # Coerce the name to a string
        #
        # @return [String]
        #
        # @api private
        def to_s
          to_a.join(SEPARATOR)
        end

        # Coerce the name to a symbol
        #
        # @return [Symbol]
        #
        # @api private
        def to_sym
          to_s.to_sym
        end

        # Coerce the name to an array
        #
        # @return [Array]
        #
        # @api private
        def to_a
          [ left.to_sym, right_name ]
        end

        # Coerce the name to a connector name
        #
        # @return [Symbol]
        #
        # @api private
        def to_connector_name
          [ left.to_sym, relationship.name ].join(SEPARATOR).to_sym
        end

        private

        # @api private
        def right_name
          relationship && relationship.operation ? relationship.name : right.to_sym
        end

      end # class NodeName

    end # class Builder
  end # class RelationRegistry
end # module DataMapper
