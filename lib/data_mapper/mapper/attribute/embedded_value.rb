module DataMapper
  class Mapper
    class Attribute

      class EmbeddedValue < Attribute

        # Error raised when type option is missing
        MissingTypeOptionError = Class.new(StandardError)

        # The mapper used for mapping this embedded value attribute
        #
        # @return [Mapper]
        #
        # @api private
        attr_reader :mapper

        # Initialize a new embedded value attribute instance
        #
        # @see Attribute#initialize
        #
        # @return [undefined]
        #
        # @api private
        def initialize(name, options = {})
          super
          @type    = options.fetch(:type) { raise(MissingTypeOptionError) }
          @aliases = options.fetch(:aliases, {})
          @mapper  = options[:mapper]
        end

        # Finalize this embedded value attribute
        #
        # @return [self]
        #
        # @api private
        def finalize
          return self if mapper

          mapper = DataMapper[type]
          mapper = mapper.remap(@aliases) if @aliases.any?

          @mapper = mapper

          self
        end

        # The attribute's human readable representation
        #
        # @example
        #
        #   attribute = DataMapper[Person].attributes[:name]
        #   puts attribute.inspect
        #
        # @return [String]
        #
        # @api public
        def inspect
          "<##{self.class.name} @name=#{name} @mapper=#{mapper}>"
        end

        # Load this attribute's value from a tuple
        #
        # @param [(#each, #[])] tuple
        #   the tuple to load
        #
        # @return [Object]
        #
        # @api private
        def load(tuple)
          mapper.load(tuple)
        end

        # Tests wether this attribute is primitive or not
        #
        # @return [Boolean] false
        #
        # @api private
        def primitive?
          false
        end
      end # class EmbeddedValue
    end # class Attribute
  end # class Mapper
end # module DataMapper
