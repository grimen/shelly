Dir[File.expand_path(File.join(File.dirname(__FILE__), 'shelly', '**', '*.rb'))].uniq.each do |file|
  require file
end

require 'net/http'
require 'uri'

module Shelly
  
  # For debugging purposes
  DEBUG = {
      :github => 'grimen/my_shell_scripts/install_geoip-city.sh/89ac494d95710c99a50e41d3a3b92ef8c474c88f',
      :gist => '90101',
      :pastie => '436580',
      :pastebin => "m6758e75f"
    }
    
  VALID_SCRIPT_SOURCES = [:github, :gist, :pastie, :pastebin, :raw].freeze
  VALID_COMMANDS = {
      :create => [:config],
      :add => [:repo, :alias],
      :remove => [:repo, :alias],
      :list => [:repos, :aliases],
      :help => []
    }.freeze
  
  def internet_connection?
    uri = URI('http://google.com')
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
  
  def valid_alias?(arg)
    Shelly::Store::Alias.include?(arg)
  end
  
  def valid_repo?(arg)
    Shelly::Store::Repo.include?(arg)
  end
  
  def valid_script_source?(arg)
    VALID_SCRIPT_SOURCES.include?(arg.to_sym)
  end
  
  def valid_command?(*args)
    if args.size > 1
      VALID_COMMANDS[args[0].to_sym].include?(args[1].to_sym)
    else
      VALID_COMMANDS.keys.include?(args[0].to_sym)
    end
  end
  
  def run!(args)
    
    args ||= []
    args.collect! { |arg| arg.strip }
    
    puts "============================================================================="
    puts "  SHELLY"
    puts "=============================================================================\n"
      
    unless Shelly.internet_connection?
      puts "[shelly]: You are not connected to the Internet."
    else
      unless args.empty?
        
        if valid_alias?(args[0])
          args[0] = Shelly::Store::Alias.config[args[0].to_s]
        elsif valid_repo?(args[0])
          # TODO: Get repo
        end
          
        if Shelly.valid_command?(args[0])
          if Shelly.valid_command?(args[0], args[1])
            case args[0].to_sym
            when :create then Shelly.create!(args[1])
            when :add then Shelly.add!(args[1], args[2])
            when :remove then Shelly.remove!(args[1], args[2])
            when :list then Shelly.list(args[1])
            when :help then Shelly.help(args[1])
            end
          else
            puts "[shelly]: FAIL: '#{args[1]}' is not a valid command for '#{args[0]}'. Try 'help' for help."
          end
          
        elsif valid_script_source?(script_source = args[0].split(':').first.to_sym)
          # For debugging purposes
          script_id = DEBUG[script_source]
          
          case script_source
          when :github then Shelly::ScriptSource::Scm::Github.new(script_id).run!
          when :gist then Shelly::ScriptSource::Plain::Gist.new(script_id).run!
          when :pastie then Shelly::ScriptSource::Plain::Pastie.new(script_id).run!
          when :pastebin then Shelly::ScriptSource::Plain::Pastebin.new(script_id).run!
          when :raw then Shelly::ScriptSource::Plain::Raw.new(script_id).run!
          end
        else
          Shelly::ScriptSource::Plain::Raw.new(script_id).run!
        end
        
      else
        puts "[shelly]: FAIL: No valid command or script source specified."
      end
    end
    
    print "\n"
    # puts "[shelly]: END\n"
    
  end
  
  def create!(what)
    case what.to_sym
    when :config then Shelly::Store::Base.create_root_config!
    end
  end
  
  def add!(to, what)
    case to.to_sym
    when :repo then Shelly::Store::Repo.add(what)
    when :alias then Shelly::Store::Alias.add(what)
    end
  end
  
  def remove!(from, what)
    case from.to_sym
    when :repo then Shelly::Store::Repo.remove(what)
    when :alias then Shelly::Store::Alias.remove(what)
    end
  end
  
  def list(from)
    case from.to_sym
    when :repos then puts Shelly::Store::Repo.list
    when :aliases then puts Shelly::Store::Alias.list
    else puts Shelly::Store::Base.list
    end
  end
  
  # TODO: Implement help instructions
  def help(from)
    puts "No help available."
  end
  
  extend self
  
end