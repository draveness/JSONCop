module JSONCop
  class Analyzer

    require 'jsoncop/model/model'
    require 'jsoncop/model/attribute'

    JSON_COP_ENABLED = content =~ /jsoncop: enabled/

    MODEL_NAME_REGEX = /(struct|class)\s+(.+)\s*{/
    ATTRIBUTE_REGEX = /^\s+(let|var)\s(.+):(.+)/
    JSON_TRANSFORMER_REGEX = /^\s+static\s+func\s+(.+)JSONTransformer.+->.+/
    JSON_BY_PROPERTY_HASH_REGEX = /static func JSONKeyPathByPropertyKey\(\)\s*->\s*\[String\s*:\s*String\]\s*{\s*return\s*(\[[\s"a-z0-9A-Z_\-:\[\],]*)}/

    attr_reader :file_path
    attr_accessor :model

    def initialize(file_path)
      @file_path
    end

    def analyze!
      content = File.read file_path
      return unless content =~ JSON_COP_ENABLED
      content.each_line do |line|
        if line =~ model_name_regex
          model_name = line.scan(model_name_regex).flatten.last
          @model = Model::Model.new model_name
        elsif line =~ attribute_regex
          result = line.scan(attribute_regex).flatten
          @model.attributes << Attribute.new(result[1], result[2])
        elsif line =~ json_transformer_regex
          result = line.scan(json_transformer_regex).flatten
          @model.transformers << result.first
        end
      end

      json_attr_list = content.scan(json_to_property_dictionary_regex).flatten.first.clear
      json_attr_list.gsub!(/(\[|\]|")/, '')
      @model.attr_json_hash = Has[json_attr_list.split(",").map { |attr_json_pair| attr_json_pair.split(":").reverse }]
    end

  end
end
