require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module Store
    class Alias < Shelly::Store::Base
      
      ALIASES_CONFIG_KEY = 'aliases'.freeze
      
      class << self
        
        def add(what)
          what_parts = what.split(':')
          config = self.load_config
          config[ALIASES_CONFIG_KEY] ||= {}
          config[ALIASES_CONFIG_KEY][what_parts.shift.to_s] = what_parts.join(':').to_s
          self.store_config(config)
        end
        
        def remove(what)
          what_parts = what.split(':')
          config = self.load_config
          config[ALIASES_CONFIG_KEY].delete(what.to_s)
          self.store_config(config)
        end
        
        def list
          self.load_config[ALIASES_CONFIG_KEY].to_yaml
        end
        
      end
      
    end
  end
end