require 'colored'
require 'claide'

module JSONCop
  class Command < CLAide::Command
    require "jsoncop/command/install"
    require "jsoncop/command/uninstall"

    self.abstract_command = true
    self.command = 'cop'
    self.version = VERSION
    self.description = 'JSONCop, the JSON parsing methods generator.'
    self.plugin_prefixes = %w(claide meta)

    def self.run(argv)
      super(argv)
    end

    def self.options
      super
    end

    def initialize(argv)
      super
    end
  end
end
