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
        content.gsub!(/\/\/ jsoncop: generate-start[^$]*jsoncop: generate\-end/, "")
      end
      File.write file_path, content + json_cop_template
    end

    def json_cop_template
      <<-JSONCOP
// jsoncop: generate-start

extension #{@model.name} {
    static func parse(json: [String: Any]) -> #{@model.name}? {
        guard #{json_parsing_template} else { return nil }
        return #{@model.name}(#{model.key_value_pair})
    }
    static func parse(jsons: [[String: Any]]) -> [#{@model.name}] {
        return jsons.flatMap(parse)
    }
}

// jsoncop: generate-end
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
