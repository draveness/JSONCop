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
        content.gsub!(/\/\/\ jsoncop: generated\-start.*\/\/jsoncop: generated\-end/, "")
      end
      p content
    end

  end
end
