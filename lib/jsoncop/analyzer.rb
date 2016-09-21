module JSONCop
  class Analyzer

    require 'jsoncop/model/model'
    require 'jsoncop/model/attribute'
    require 'jsoncop/model/transformer'

    JSON_COP_ENABLED = /@jsoncop/

    NEED_PARSING_CONTENT = /(\/\/\s*@jsoncop\s+(?:struct|class)(?:.|\s)*?\n})/
    MODEL_NAME_REGEX = /(struct|class)\s+(.+)\s*{/
    ATTRIBUTE_REGEX = /^\s+(let|var)\s(.+):(.+)/
    JSON_TRANSFORMER_REGEX = /^\s+static\s+func\s+(.+)JSONTransformer\(.+?\:(.+)\).+->.+/
    JSON_BY_PROPERTY_HASH_REGEX = /static\s+func\s+JSONKeyPathByPropertyKey\(\)\s*->\s*\[String\s*:\s*String\]\s*{\s*return\s*(\[[\s\."a-z0-9A-Z_\-:\[\],]*)}/

    attr_reader :file_path
    attr_accessor :current_model

    def initialize(file_path)
      @file_path = file_path
    end

    def analyze!
      content = File.read file_path
      return unless content =~ JSON_COP_ENABLED
      models = []
      content.scan(NEED_PARSING_CONTENT).flatten.each do |content|
        content.each_line do |line|
          if line =~ MODEL_NAME_REGEX
            model_name = line.scan(MODEL_NAME_REGEX).flatten.last
            @current_model = Model::Model.new model_name
            models << @current_model
          elsif line =~ ATTRIBUTE_REGEX
            result = line.scan(ATTRIBUTE_REGEX).flatten
            @current_model.attributes << Model::Attribute.new(result[1], result[2])
          elsif line =~ JSON_TRANSFORMER_REGEX
            result = line.scan(JSON_TRANSFORMER_REGEX).flatten
            @current_model.transformers << Model::Transformer.new(result[0], result[1])
          end
        end

        json_attr_list = content.scan(JSON_BY_PROPERTY_HASH_REGEX).flatten.first
        if json_attr_list
          json_attr_list.gsub!(/[(\[\]"\s)]*/, '')
          @current_model.attr_json_hash = Hash[json_attr_list.split(",").map {
            |attr_json_pair| attr_json_pair.split(":")
          }]
        end
      end

      models
    end

  end
end
