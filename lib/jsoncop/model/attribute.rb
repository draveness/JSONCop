module JSONCop
  module Model
    class Attribute
      attr_reader :name, :type
      def initialize(name, type)
          @name = name.gsub(/\s+/, "")
          @type = type.gsub(/\s+/, "")
      end

      def real_type
        return type[0..-2] if type.end_with? "?"
        return type
      end

      def optional_type
        return type if type.end_with? "?"
        return type + "?"
      end

      def decode_type
        built_in_types = %w[Int32 Int64 Bool Float Double]
        return real_type if built_in_types.include? real_type

        case real_type
        when "Int" then "Integer"
        when "Date" then "Object"
        else "Object"
        end
      end
    end
  end
end
