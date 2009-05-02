module Shelly
  module ShellScript
    
    def store!(source_url, destination_path, type)
      `sudo curl "#{source_url}" --silent -o #{destination_path}`
      raise "The specified #{type} could not be found." unless File.exist?(destination_path)
    end
    
    def make_executable!(script_path)
      `sudo chmod 777 #{script_path}`
    end
    
    def execute!(script_path)
      Shelly::ShellScript.make_executable!(script_path)
      Shelly::ShellScript.ensure_script_format!(script_path)
      puts `sudo ./bin/#{File.basename(script_path)}`
      
      # FIXME: How come this not working? Thse above don't outputs result until finished, needs solution.
      #File.open("#{script_path}", 'r') do |file|
      #  begin
      #    while line = file.gets
      #      puts line
      #      puts `sudo #{line}`
      #    end
      #  rescue StandardError => e
      #    puts "** Error: #{e}"
      #  ensure
      #    file.close
      #  end
      #end
    end
    
    def delete!(script_path)
      `sudo rm #{script_path}`
    end
    
    def ensure_script_format!(script_path)
      begin
        file = File.open(script_path, 'r')  
        script = file.read
        file.close
        file = File.open(script_path, 'w') 
        script.gsub!(/\r/, '')
        file.write(script)
      rescue StandardError => e
        puts "Error: #{e}"
      ensure
        file.close if file
      end
    end
    
    extend self
    
  end
end