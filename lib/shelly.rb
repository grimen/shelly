Dir[File.expand_path(File.join(File.dirname(__FILE__), 'script_source', '**', '*.rb'))].uniq.each do |file|
  require file
end

require 'net/http'
require 'uri'

module Shelly
  
  VALID_SCRIPT_SOURCES = [:github, :gist, :pastie, :pastebin, :raw]
  
  def store!(source_url, destination_path)
    `sudo curl "#{source_url}" --silent -o #{destination_path}`
  end
  
  def make_executable!(script_path)
    `sudo chmod 777 #{script_path}`
  end
  
  def execute!(script_path)
    Shelly.make_executable!(script_path)
    Shelly.ensure_script_format!(script_path)
    `sudo ./bin/#{File.basename(script_path)}`
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
  
  def internet_connection?
    site_url = 'http://google.com'
    uri = URI(site_url)
    begin 
      http = Net::HTTP.new(uri.host, uri.port) 
      http.open_timeout = 5
      http.start
      http.finish
      true
    rescue
      false
    end
  end
  
  def run(args)
    args = args.first.split(':')
    
    puts args.inspect
    
    script_source = args[0].to_sym
    script_identifier = args[1]
    
    # For debugging purposes
    hello_world_identifiers = {
        :github => 'grimen/my_shell_scripts/install_geoip-city.sh/89ac494d95710c99a50e41d3a3b92ef8c474c88f',
        :gist => '90101',
        :pastie => '436580',
        :pastebin => "m6758e75f"
      }
      
    unless Shelly.internet_connection?
      puts "You are not connected to the Internet."
    else
      if script_source.to_s.length > 0
        script_source = script_source.to_sym
        
        if VALID_SCRIPT_SOURCES.include?(script_source)
          puts "** Executing shell script from #{script_source}..."
          
          id = hello_world_identifiers[script_source]
          
          case script_source
          when :github then
            github_script = Shelly::ScriptSource::Scm::Github.new(id)
            github_script.run!
          when :gist then
            gist_script = Shelly::ScriptSource::Plain::Gist.new(id)
            gist_script.run!
          when :pastie then
            pastie_script = Shelly::ScriptSource::Plain::Pastie.new(id)
            pastie_script.run!
          when :pastebin
            pastebin_script = Shelly::ScriptSource::Plain::Pastebin.new(id)
            pastebin_script.run!
          when :raw
            raw_script = Shelly::ScriptSource::Plain::Raw.new(id)
            raw_script.run!
          else
            puts "FAIL: '#{script_source}' is not a valid script source."
          end
        end
      else
        puts "FAIL: No script source specified."
      end
    end
  end
  
  extend self
  
end