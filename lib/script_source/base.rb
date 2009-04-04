module Shelly
  module ScriptSource
    class Base
      
      #DEFAULT_SCRIPT_DIRECTORY = '/tmp'.freeze # could not get this to work
      DEFAULT_SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), '..', '..', 'bin') # hack to get ./* shell command to work
      DEFAULT_SCRIPT_EXTENSION = ''.freeze
      
      attr_accessor :script_file_name, :script_file_path, :fetch_url
      
      def initialize(script_identifier)
        self.fetch_url = self.script_url(script_identifier)
        self.script_file_name = self.script_name(script_identifier)
        self.script_file_path = self.script_path(self.script_file_name)
      end
      
      def run!
        begin
          puts Shelly.store!(self.fetch_url, self.script_file_path)
          puts Shelly.execute!(self.script_file_path)
          Shelly.delete!(self.script_file_path)
        rescue StandardError => m
          puts "Error: #{m}"
        end
      end
      
      def aliases
        @aliases ||= nil
      end
      
      def repos
        @repos ||= nil
      end
      
      protected
      
      def script_name(id)
        class_name = self.class.to_s.split('::').last.downcase
        "#{class_name}_#{id}"
      end
      
      def script_path(script_name)
        File.join(DEFAULT_SCRIPT_DIRECTORY, "#{script_name}#{DEFAULT_SCRIPT_EXTENSION}")
      end
      
      def script_url
        raise "Error: Should implement 'script_url'."
      end
      
    end
  end
end