module JSONCop
  class Command
    class Install < Command

      require "jsoncop/analyzer"
      require "jsoncop/generator"

      self.summary = ""
      self.description = <<-DESC
      DESC

      def initialize(argv)
        super
      end

      def run
        Dir.glob("**/*.swift").each do |file|
          analyzer = create_analyzer_for_file file
          model = analyzer.analyze!
          next unless model

          generator = create_generator_for_file file, model
          generator.generate!
        end
      end

      def create_analyzer_for_file(file_path)
        Analyzer.new file_path
      end

      def create_generator_for_file(file_path, model)
        Generator.new file_path, model
      end
    end
  end
end
