require 'yaml'

module Shelly
  module Store
    class Base
      
      DEFAULT_CONFIG_FILE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'shelly.yml')).freeze
      CUSTOM_CONFIG_FILE_PATH = '' # File.expand_path(File.join('~', '.shelly')).freeze
      
      class << self
        
        def config
          load_config
        end
        
        def create_root_config!
          `sudo cp #{self::DEFAULT_CONFIG_FILE_PATH} #{self::CUSTOM_CONFIG_FILE_PATH}`
        end
        
        def config_file_path
          File.exist?(self::CUSTOM_CONFIG_FILE_PATH) ? self::CUSTOM_CONFIG_FILE_PATH : self::DEFAULT_CONFIG_FILE_PATH
        end
        
        def load_config
          config_hash = YAML.load_file(self.config_file_path) || Hash.new
        end
        
        def store_config(config_hash)
          File.open(config_file_path, 'w') do |file|
            YAML.dump(config_hash, file)
          end
        end
        
        def list
          load_config.to_yaml rescue ''
        end
        
        def include?(arg)
          config = load_config
          config[self.class.name.downcase.to_sym].keys.include?(arg) rescue false
        end
        
      end
      
    end
  end
end