module JSONCop
  module Helper
    class String
      def clear_white_space
          self.gsub(/\s+/, "")
      end
    end
  end
end
