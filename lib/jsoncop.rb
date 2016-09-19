require "jsoncop/version"

module JSONCop

  class Informative < StandardError; end

  require 'jsoncop/version'
  require 'jsoncop/helper'

  autoload :Command,   'jsoncop/command'
end
