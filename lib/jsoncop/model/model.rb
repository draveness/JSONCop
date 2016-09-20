module JSONCop
  module Model
    class Model
      attr_reader :name
      attr_accessor :is_struct
      attr_accessor :attributes
      attr_accessor :transformers
      attr_accessor :attr_json_hash

      def initialize(name)
          @name = name.gsub(/\s+/, "")
          @attributes = []
          @transformers = []
          @attr_json_hash = {}
      end

      def key_value_pair
        attributes.map { |attribute| "#{attribute.name}: #{attribute.name}" }.join(", ")
      end
    end
  end
end
