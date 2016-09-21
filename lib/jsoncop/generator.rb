module JSONCop
  class Generator

    require 'jsoncop/model/model'
    require 'jsoncop/model/attribute'

    attr_reader :file_path
    attr_reader :model

    def initialize(file_path, models)
      @file_path = file_path
      @models = models
    end

    def generate!
      jsoncop_generate_start = /\/\/ MARK: \- JSONCop\-Start/
      jsoncop_generate_end = /\/\/ JSONCop\-End/
      content = File.read file_path
      if content.match(jsoncop_generate_start) && content.match(jsoncop_generate_end)
        content.gsub!(/\/\/ MARK: \- JSONCop\-Start[^$]*JSONCop\-End/, json_cop_template)
      else
        content += json_cop_template
      end
      File.write file_path, content
    end

    def json_cop_template
      result = "// MARK: - JSONCop-Start\n\n"
      @models.each do |model|
        result += <<-JSONCOP
extension #{model.name} {
    static func parse(json: Any) -> #{model.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_parsing_template model} else { return nil }
        return #{model.name}(#{model.key_value_pair})
    }
    static func parses(jsons: Any) -> [#{model.name}] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

JSONCOP
#         result += <<-CODING
# extension #{model.name}: NSCoding {
#     func encode(with aCoder: NSCoder) {
#
#     }
#
#     init?(coder decoder: NSCoder) {
#         guard #{decode_template model} else { return nil }
#
#         self.init(#{model.key_value_pair})
#     }
# }
#
# CODING
      end
      result += "// JSONCop-End"
      result
    end

    def json_parsing_template(model)
      model.attributes.map do |attr|
        transformer = model.transformers.select { |t| t.name == attr.name }.first
        attr_key_path = model.attr_json_hash[attr.name] || attr.name
        return unless attr_key_path
        value = "json"
        key_paths = attr_key_path.split(".")
        key_paths.each_with_index do |key, index|
          value.insert 0, "("
          value += "[\"#{key}\"] as? "
          if index == key_paths.count - 1
            if transformer
              value += "#{transformer.type})"
              value += ".flatMap(#{attr.name}JSONTransformer)"
            else
              value += "#{attr.type})"
            end
          else
            value += "[String: Any])?"
          end
        end

        "let #{attr.name} = #{value}"
      end.join(",\n\t\t\t")
    end

    def decode_template(model)
      model.attributes.map do |attr|
        "let #{attr.name} = decoder.decode#{attr.decode_type}(forKey: \"#{attr.name}\") as? #{attr.type}"
      end.join(",\n\t\t\t")
    end

  end
end
