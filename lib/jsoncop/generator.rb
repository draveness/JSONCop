module JSONCop
  class Generator

    require 'jsoncop/model/model'
    require 'jsoncop/model/attribute'

    attr_reader :file_path
    attr_reader :model

    def initialize(file_path, model)
      @file_path = file_path
      @model = model
    end

    def generate!
      jsoncop_generate_start = /jsoncop: generate\-start/
      jsoncop_generate_end = /jsoncop: generate\-end/
      content = File.read file_path
      if content.match(jsoncop_generate_start) && content.match(jsoncop_generate_end)
        content.gsub!(/\/\/ jsoncop: generate-start[^$]*jsoncop: generate\-end/, json_cop_template)
      else
        content += json_cop_template
      end
      File.write file_path, content
    end

    def json_cop_template
      <<-JSONCOP
// jsoncop: generate-start

extension #{@model.name} {
    static func parse(json: Any) -> #{@model.name}? {
        guard let json = json as? [String: Any] else { return nil }
        guard #{json_parsing_template} else { return nil }
        return #{@model.name}(#{model.key_value_pair})
    }
    static func parses(jsons: Any) -> [#{@model.name}] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

// jsoncop: generate-end
      JSONCOP
    end

    def json_parsing_template
      @model.attributes.map do |attr|
        transformer = @model.transformers.select { |t| t.name == attr.name }.first
        if transformer
          "let #{attr.name} = (json[\"#{@model.attr_json_hash[attr.name] || attr.name}\"] as? #{transformer.type}).flatMap(#{attr.name}JSONTransformer)"
        else
          "let #{attr.name} = json[\"#{@model.attr_json_hash[attr.name] || attr.name}\"] as? #{attr.type}"
        end
      end.join(",\n\t\t\t")
    end
  end
end
