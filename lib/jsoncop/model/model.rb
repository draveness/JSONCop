module JSONCop
  module Model
    class Model
      attr_reader :name
      attr_accessor :attributes
      attr_accessor :transformers
      attr_accessor :json_attr_hash

      def initialize(name)
          @name = name.clear
          @attributes = []
          @transformers = []
          @json_attr_hash = {}
      end
    end
  end
end
