require "xcodeproj"

module JSONCop
  class Command
    class Integrate < Command

      BUILD_PHASE_PREFIX = "[JC] ".freeze

      JSONCOP_INSTALL_PHASE_NAME = "JSONCop Install Script".freeze

      self.summary = ""
      self.description = <<-DESC
      DESC

      def initialize(argv)
        super
      end

      def run
        project = Xcodeproj::Project.open(Dir.glob("*.xcodeproj").first)
        native_target = project.targets.first
        phase = create_or_update_build_phase(native_target, JSONCOP_INSTALL_PHASE_NAME)
        phase.shell_path = "/usr/bin/ruby"
        phase.shell_script = install_shell_script
        project.save
      end

      def create_or_update_build_phase(target, phase_name, phase_class = Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
        prefixed_phase_name = BUILD_PHASE_PREFIX + phase_name
        build_phases = target.build_phases.grep(phase_class)
        build_phases.find { |phase| phase.name && phase.name.end_with?(phase_name) }.tap { |p| p.name = prefixed_phase_name if p } ||
          target.project.new(phase_class).tap do |phase|
            # UI.message("Adding Build Phase '#{prefixed_phase_name}' to project.") do
              phase.name = prefixed_phase_name
              phase.show_env_vars_in_log = '0'
              target.build_phases << phase
            # end
          end
      end

      def install_shell_script
        <<-SCRIPT#!/usr/bin/env ruby
require 'jsoncop'
Encoding.default_external = Encoding::UTF_8
JSONCop::Command.run(["install"])
        SCRIPT
      end
    end
  end
end
