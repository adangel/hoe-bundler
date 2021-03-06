class Hoe #:nodoc:
  #
  #  Rake task to generate a bundler Gemfile based on your declared hoe dependencies.
  #
  #  * <tt>bundler:gemfile</tt>
  #
  module Bundler
    VERSION = "1.4.0" #:nodoc:

    def define_bundler_tasks
      desc "generate a bundler Gemfile from your Hoe.spec dependencies"
      task "bundler:gemfile" do
        File.open("Gemfile","w") do |gemfile|
          gemfile.print hoe_bundler_contents
        end
      end
    end

    def hoe_bundler_contents
      gemfile = StringIO.new
      gemfile.puts "# -*- ruby -*-"
      gemfile.puts
      gemfile.puts "# DO NOT EDIT THIS FILE. Instead, edit Rakefile, and run `rake bundler:gemfile`."
      gemfile.puts
      gemfile.puts "source \"https://rubygems.org/\""
      gemfile.puts

      hoe_bundler_add_dependencies(self.extra_deps, gemfile)
      hoe_bundler_add_dependencies(self.extra_dev_deps, gemfile, ", :group => [:development, :test]")
      gemfile.puts "# vim: syntax=ruby"

      gemfile.rewind
      gemfile.read
    end

    def hoe_bundler_add_dependencies(deps, gemfile, postfix=nil)
      deps2 = {}
      deps.each do |name, version|
        version ||= ">=0"
        deps2[name] = version unless deps2.key?(name)
      end
      deps2.each do |name, version|
        output = [%Q{gem "#{name}"}]
        Array(version).each do |ver|
          output << %Q{"#{ver.gsub(/ /,'')}"}
        end
        gemfile.puts %Q{#{output.join(", ")}#{postfix}}
      end
      gemfile.puts
    end
  end
end
