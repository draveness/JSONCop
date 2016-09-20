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
      jsoncop_generate_end = /\/\/ MARK: \- JSONCop\-End/
      content = File.read file_path
      if content.match(jsoncop_generate_start) && content.match(jsoncop_generate_end)
        content.gsub!(/\/\/ MARK: \- JSONCop\-Start[^$]*MARK: \- JSONCop\-End/, json_cop_template)
      else
        content += json_cop_template
      end
      File.write file_path, content
    end

    def json_cop_template
      result = "// MARK: - JSONCop-End\n\n"
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

extension #{model.name}: NSCoding {
    func encode(with aCoder: NSCoder) {

    }

    init?(coder decoder: NSCoder) {
        guard #{decode_template model} else { return nil }

        self.init(#{model.key_value_pair})
    }
}

JSONCOP
      end
      result += "// MARK: - JSONCop-End"
      result
    end

    def json_parsing_template(model)
      model.attributes.map do |attr|
        transformer = model.transformers.select { |t| t.name == attr.name }.first
        if transformer
          "let #{attr.name} = (json[\"#{model.attr_json_hash[attr.name] || attr.name}\"] as? #{transformer.type}).flatMap(#{attr.name}JSONTransformer)"
        else
          "let #{attr.name} = json[\"#{model.attr_json_hash[attr.name] || attr.name}\"] as? #{attr.type}"
        end
      end.join(",\n\t\t\t")
    end

    def decode_template(model)
      model.attributes.map do |attr|
        "let #{attr.name} = decoder.decode#{attr.type}(forKey: \"#{attr.name}\")"
      end.join(",\n\t\t\t")
    end

  end
end
