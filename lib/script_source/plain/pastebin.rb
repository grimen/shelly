module Shelly
  module ScriptSource
    module Plain
      class Pastebin < Shelly::ScriptSource::Base
        
        SCRIPT_SOURCE_BASE_URL = 'http://pastebin.com'.freeze
        
        protected
        
        def script_url(pastebin_id)
          "#{SCRIPT_SOURCE_BASE_URL}/pastebin.php?dl=#{pastebin_id}"
        end
        
      end
    end
  end
end