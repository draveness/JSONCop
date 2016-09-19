module JSONCop
  module Model
    class Attribute
        attr_reader :name, :type
        def initialize(name, type)
            @name = name.clear
            @type = type.clear
        end
    end
  end
end
