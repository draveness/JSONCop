module JSONCop
  class Command
    class Uninstall < Command
      self.summary = ""
      self.description = <<-DESC
      DESC

      def initialize(argv)
        super
      end

      def run
        Dir.glob("**/*.swift").each do |file_path|
          jsoncop_generate_start = /jsoncop: generate\-start/
          jsoncop_generate_end = /jsoncop: generate\-end/
          content = File.read file_path
          if content.match(jsoncop_generate_start) && content.match(jsoncop_generate_end)
            content.gsub!(/\/\/ jsoncop: generate-start[^$]*jsoncop: generate\-end/, "")
          end
          File.write file_path, content
        end
      end
    end
  end
end
