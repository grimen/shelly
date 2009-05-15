module Shelly
  module ShellScript
    
    def store!(source_url, destination_path, type)
      `sudo curl "#{source_url}" --silent -o #{destination_path}`
      raise "The specified #{type} could not be found." unless File.exist?(destination_path)
    end
    
    def make_executable!(script_path)
      `sudo chmod 777 #{script_path}` if File.exist?(script_path)
    end
    
    def execute!(script_path)
      if self.valid?(script_path)
        self.make_executable!(script_path)
        self.ensure_format!(script_path)
        self.execute_with_output!(script_path, false)
      else
        puts "Invalid script source."
      end
    end
    
    def execute_with_output!(script_path, advanced = false)
      if advanced
        # Runs the script with output directly, but causes paths to be wrong. =/
        File.open(script_path, 'r') do |file|
          begin
            while line = file.gets
              # Print shell script instruction
              # print line
              # Run everyting except empty lines and comments + print out result.
              print `#{line.strip}` unless line =~ /^(\#|\n)/
            end
          rescue StandardError => e
            puts "Error: #{e}"
          ensure
            file.close
          end
        end
      else
        puts `sudo #{script_path}`
      end
    end
    
    def delete!(script_path)
      `sudo rm #{script_path}` if File.exist?(script_path)
    end
    
    def valid?(script_path)
      File.open(script_path, 'r') do |file|
        begin
          script = file.read
          # Contains a shebang? I.e. is it a valid script?
          script =~ /\#\!\/bin/
        rescue StandardError => e
          puts "Error: #{e}"
        ensure
          file.close
        end
      end
    end
    
    def ensure_format!(script_path)
      File.open(script_path, 'r+') do |file|
        begin
          script = file.read
          # Remove invalid new-line returns
          script.gsub!(/\r/, '')
          file.write(script)
        rescue StandardError => e
          puts "Error: #{e}"
        ensure
          file.close
        end
      end
    end
    
    extend self
    
  end
end