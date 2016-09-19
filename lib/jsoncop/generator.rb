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
      jsoncop_generated_start = /jsoncop: generated\-start/
      jsoncop_generated_end = /jsoncop: generated\-end/
      content = File.read file_path
      if content.match(jsoncop_generated_start) && content.match(jsoncop_generated_end)
        content.gsub!(/\/\/ jsoncop: generated-start[^$]*jsoncop: generated\-end/, "")
      end
      File.write file_path, content + json_cop_template
    end

    def json_cop_template
      <<-JSONCOP
// jsoncop: generated-start

extension #{@model.name} {
    static func parse(json: [String: Any]) -> #{@model.name}? {
        guard #{json_parsing_template} else { return nil }
        return #{@model.name}(#{model.key_value_pair})
    }
    static func parses(jsons: [[String: Any]]) -> [#{@model.name}] {
        return jsons.flatMap(parse)
    }
}

// jsoncop: generated-end
      JSONCOP
    end

    def json_parsing_template
      @model.attributes.map do |attr|
        if @model.transformers.include? attr.name
          "let #{attr.name} = (json[\"#{@model.attr_json_hash[attr.name]}\"]).flatMap(#{attr.name}JSONTransformer)"
        else
          "let #{attr.name} = json[\"#{@model.attr_json_hash[attr.name]}\"] as? #{attr.type}"
        end
      end.join(",\n\t\t")
    end
  end
end
