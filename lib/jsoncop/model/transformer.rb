module JSONCop
  module Model
    class Transformer
      attr_reader :name, :type
      def initialize(name, type)
          @name = name.gsub(/\s+/, "")
          @type = type.gsub(/\s+/, "").gsub(/:/, ": ")
      end
    end
  end
end
