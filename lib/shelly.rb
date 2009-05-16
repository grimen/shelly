Dir[File.expand_path(File.join(File.dirname(__FILE__), 'shelly', '**', '*.rb'))].uniq.each do |file|
  require file
end

require 'net/http'
require 'uri'

module Shelly
  
  VALID_SCRIPT_SOURCES = [:github, :gist, :pastie, :pastebin, :raw].freeze
  VALID_COMMANDS = {
      :run => [],
      :create => [:config],
      :add => [:repo, :alias],
      :remove => [:repo, :alias],
      :list => [:repos, :aliases],
      :help => []
    }.freeze
    
  def run(args)
    (args ||= []).collect! { |arg| arg.strip }
    
    unless Shelly.internet_connection?
      puts "[shelly]: You are not connected to the Internet."
    else
      unless args.empty?
        if Shelly.valid_command?(args[0], args[1])
          case args[0].to_sym
          when :run then Shelly.run!(args[1])
          when :create then Shelly.create!(args[1])
          when :add then Shelly.add!(args[1], args[2])
          when :remove then Shelly.remove!(args[1], args[2])
          when :list then Shelly.list(args[1])
          when :help then Shelly.help(args[1])
          end
        else
          puts "[shelly]: FAIL: '#{args[1]}' is not a valid command for '#{args[0]}'. Try 'help' for help."
        end
      else
        puts "[shelly]: FAIL: No valid command."
      end
    end
    
  end
  
  def run!(what)
    if what
      begin
        if Shelly::Store::Alias.include?(what)
          # Alias, e.g. "shelly run hello_world"
          what = Shelly::Store::Alias.value(what)
        elsif Shelly::Store::Repo.include?(what)
          # File from repo, e.g. "shelly run hello_world"
          what = Shelly::Store::Repo.value(what)
        end
        
        if what.include?(':')
          # Explicit script source, e.g. "shelly run pastie:1234"
          whats = what.split(':')
          script_source = whats.shift.to_sym
          script_id = whats.join('/')
          
          puts what
          if valid_script_source?(script_source)
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
          puts "[shelly]: FAIL: No valid script source."
        end
      rescue StandardError => e
        puts "#{e}"
      end
    else
      puts "[shelly]: Invalid args for RUN."
    end
  end
  
  def create!(what)
    if what
      case what.to_sym
      when :config then Shelly::Store::Base.create_root_config!
      end
    else
      puts "[shelly]: Invalid args for CREATE."
    end
  end
  
  def add!(to, what)
    if to
      case to.to_sym
      when :repo then Shelly::Store::Repo.add(what)
      when :alias then Shelly::Store::Alias.add(what)
      end
    else
      puts "[shelly]: Invalid args for ADD."
    end
  end
  
  def remove!(from, what)
    if from
      case from.to_sym
      when :repo then Shelly::Store::Repo.remove(what)
      when :alias then Shelly::Store::Alias.remove(what)
      end
    else
      puts "[shelly]: Invalid args for REMOVE."
    end
  end
  
  def list(from)
    case (from ||= :all).to_sym
    when :repos then puts Shelly::Store::Repo.list
    when :aliases then puts Shelly::Store::Alias.list
    else puts Shelly::Store::Base.list
    end
  end
  
  # TODO: Implement help instructions
  def help(from)
    puts "[shelly]: No help available."
  end
  
  extend self
  
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
  
  def valid_repo_file?(arg)
    Shelly::Store::Repo.include_file?(arg)
  end
  
  def valid_script_source?(arg)
    VALID_SCRIPT_SOURCES.include?(arg.to_sym)
  end
  
  def valid_command?(*args)
    if args[1]
      VALID_COMMANDS[args[0].to_sym].empty? || VALID_COMMANDS[args[0].to_sym].include?(args[1].to_sym)
    else
      VALID_COMMANDS.keys.include?(args[0].to_sym)
    end
  end
  
end