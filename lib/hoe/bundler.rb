class Hoe #:nodoc:
  #
  #  Rake task to generate a bundler Gemfile based on your declared hoe dependencies.
  #
  #  * <tt>bundler:gemfile</tt>
  #
  module Bundler
    VERSION = "1.1.0" #:nodoc:

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
      self.extra_deps.each do |name, version|
        version ||= ">=0"
        gemfile.puts %Q{gem "#{name}", "#{version.gsub(/ /,'')}"}
      end
      gemfile.puts
      self.extra_dev_deps.each do |name, version|
        version ||= ">=0"
        gemfile.puts %Q{gem "#{name}", "#{version.gsub(/ /,'')}", :group => [:development, :test]}
      end
      gemfile.puts
      gemfile.puts "# vim: syntax=ruby"
      gemfile.rewind
      gemfile.read
    end
  end
end
