require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module Store
    class Alias < Shelly::Store::Base
      
      CONFIG_KEY = 'aliases'.freeze
      
      class << self
        
        def add(what)
          whats = what.split(':')
          config = self.load_config
          config[CONFIG_KEY] ||= {}
          config[CONFIG_KEY].merge!(whats.shift => whats.join(':'))
          self.store_config(config)
        end
        
        def remove(what)
          whats = what.split(':')
          config = self.load_config
          config[CONFIG_KEY].delete(whats.shift)
          config[CONFIG_KEY] = nil if config[CONFIG_KEY] == {}
          self.store_config(config)
        end
        
        def list
          self.config.to_yaml
        end
        
        def include?(key)
          config = load_config
          config[CONFIG_KEY].keys.include?(key) rescue false
        end
        
        def value(key)
          "#{config[CONFIG_KEY][key.to_s]}"
        end
        
      end
      
    end
  end
end