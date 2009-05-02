require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module ScriptSource
    module Plain
      class Pastebin < Shelly::ScriptSource::Plain::Base
        
        SCRIPT_SOURCE_BASE_URL = 'pastebin.com'.freeze
        
        protected
        
        def script_url(pastebin_id)
          "http://#{SCRIPT_SOURCE_BASE_URL}/pastebin.php?dl=#{pastebin_id}"
        end
        
      end
    end
  end
end