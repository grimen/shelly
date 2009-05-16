require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

require 'activesupport'

module Shelly
  module Store
    class Repo < Shelly::Store::Base
      
      CONFIG_KEY = 'repos'.freeze
      
      class << self
        
        def add(what)
          whats = what.split(':')
          config = self.load_config
          config[CONFIG_KEY] ||= {}
          config[CONFIG_KEY][whats[0].to_s] ||= []
          config[CONFIG_KEY][whats[0].to_s] << whats[1]
          self.store_config(config)
        end
        
        def remove(what)
          whats = what.split(':')
          config = self.load_config
          config[CONFIG_KEY][whats[0].to_s].delete(whats[1].to_s) if config[CONFIG_KEY][whats[0].to_s]
          config[CONFIG_KEY][whats[0].to_s] = nil if config[CONFIG_KEY][whats[0].to_s] == []
          self.store_config(config)
        end
        
        def list
          self.load_config[CONFIG_KEY].to_yaml
        end
        
        def include?(file_name)
          files(file_name).present? rescue false
        end
        
        def files(match_file_name = nil)
          @repo = nil
          @file_names = []
          config = load_config
          config[CONFIG_KEY].each do |host, repos|
            scm_class = "Shelly::ScriptSource::Scm::#{host.classify}".constantize
            repos.each do |repo|
              files = scm_class.files(*repo.split('/'))
              @file_names << files
              @repo = "#{host}:#{repo}/#{match_file_name}" if files.include?(match_file_name)
            end
          end
          @file_names = @file_names.flatten.compact
          @repo
        end
        
        def value(file_name)
          files(file_name)
        end
        
      end
      
    end
  end
end