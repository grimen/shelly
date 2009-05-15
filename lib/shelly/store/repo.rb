require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

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
        
      end
      
    end
  end
end