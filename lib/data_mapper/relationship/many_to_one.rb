module DataMapper
  class Relationship

    class ManyToOne < self

      private

      # @api private
      def default_source_key
        foreign_key_name
      end

      # @api private
      def default_target_key
        :id
      end
    end # class ManyToOne
  end # class Relationship
end # module DataMapper
