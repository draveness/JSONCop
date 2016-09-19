module JSONCop
  module Helper
    class String
      def clear
          self.gsub(/\s+/, "")
      end
    end
  end
end
