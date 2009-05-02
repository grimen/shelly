require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module Store
    class Repo < Shelly::Store::Base
      
      REPOS_CONFIG_KEY = 'repos'.freeze
      
      class << self
        
        def add(what)
          # TODO
        end
        
        def remove(what)
          # TODO
        end
        
        def list
          self.load_config[REPOS_CONFIG_KEY].to_yaml
        end
        
      end
      
    end
  end
end