module Shelly
  module ScriptSource
    class Base
      
      DEFAULT_SCRIPT_DIRECTORY = '/tmp'.freeze # could not get this to work
      DEFAULT_SCRIPT_EXTENSION = ''.freeze
      
      attr_accessor :script_file_name, :script_file_path, :fetch_url
      
      def initialize(script_identifier)
        self.fetch_url = self.script_url(script_identifier)
        self.script_file_name = self.script_name(script_identifier)
        self.script_file_path = self.script_path(self.script_file_name)
      end
      
      def run!
        begin
          puts "[shelly]: Script source type: #{self.script_source.upcase}"
          puts "[shelly]: Script source URL: #{self.fetch_url}"
          
          print "[shelly]: Fetching script..."
          Shelly::ShellScript.store!(self.fetch_url, self.script_file_path, 'script')
          print "DONE\n"
          
          puts "[shelly]: Executing script..."
          puts "============================================================== SCRIPT ======="
          Shelly::ShellScript.execute!(self.script_file_path)
          puts "============================================================================="
          
          print "[shelly]: Cleaning up..."
          Shelly::ShellScript.delete!(self.script_file_path)
          print "DONE\n"
          
          puts "[shelly]: END\n"
          
        rescue StandardError => m
          puts "[shelly]: Error: #{m}"
        end
      end
      
      protected
      
      def script_source
        self.class.to_s.split('::').last.downcase
      end
      
      def script_name(id)
        "#{self.script_source}_#{id}"
      end
      
      def script_path(script_name)
        File.expand_path(File.join(DEFAULT_SCRIPT_DIRECTORY, "#{self.script_file_name}#{DEFAULT_SCRIPT_EXTENSION}"))
      end
      
      def script_url
        raise "[shelly]: ** Error: Should implement 'script_url'."
      end
      
    end
  end
end