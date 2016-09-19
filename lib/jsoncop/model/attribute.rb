module JSONCop
  module Model
    class Attribute
      attr_reader :name, :type
      def initialize(name, type)
          @name = name.gsub(/\s+/, "")
          @type = type.gsub(/\s+/, "")
      end
    end
  end
end
