module JSONCop
  class Analyzer

    require 'jsoncop/model/model'
    require 'jsoncop/model/attribute'

    JSON_COP_ENABLED = /jsoncop: enabled/

    MODEL_NAME_REGEX = /(struct|class)\s+(.+)\s*{/
    ATTRIBUTE_REGEX = /^\s+(let|var)\s(.+):(.+)/
    JSON_TRANSFORMER_REGEX = /^\s+static\s+func\s+(.+)JSONTransformer.+->.+/
    JSON_BY_PROPERTY_HASH_REGEX = /static func JSONKeyPathByPropertyKey\(\)\s*->\s*\[String\s*:\s*String\]\s*{\s*return\s*(\[[\s"a-z0-9A-Z_\-:\[\],]*)}/

    attr_reader :file_path
    attr_accessor :model

    def initialize(file_path)
      @file_path = file_path
    end

    def analyze!
      content = File.read file_path
      return unless content =~ JSON_COP_ENABLED
      content.each_line do |line|
        if line =~ MODEL_NAME_REGEX
          model_name = line.scan(MODEL_NAME_REGEX).flatten.last
          @model = Model::Model.new model_name
        elsif line =~ ATTRIBUTE_REGEX
          result = line.scan(ATTRIBUTE_REGEX).flatten
          @model.attributes << Model::Attribute.new(result[1], result[2])
        elsif line =~ JSON_TRANSFORMER_REGEX
          result = line.scan(JSON_TRANSFORMER_REGEX).flatten
          @model.transformers << result.first
        end
      end

      json_attr_list = content.scan(JSON_BY_PROPERTY_HASH_REGEX).flatten.first.clear
      json_attr_list.gsub!(/(\[|\]|")/, '')
      @model.attr_json_hash = Hash[json_attr_list.split(",").map { |attr_json_pair| attr_json_pair.split(":").reverse }]
      p @model
    end

  end
end
