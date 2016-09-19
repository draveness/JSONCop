module JSONCop
  class Command
    class Install < Command

      require "jsoncop/analyzer"

      self.summary = ""
      self.description = <<-DESC
      DESC

      def initialize(argv)
        super
      end

      def run
        p Dir["."]
        create_analyzer_for_file
      end

      def create_analyzer_for_file(file_path)
        Analyzer.new file_path
      end
    end
  end
end
