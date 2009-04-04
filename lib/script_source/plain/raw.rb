module Shelly
  module ScriptSource
    module Plain
      class Raw < Shelly::ScriptSource::Base
        
        SCRIPT_SOURCE_BASE_URL = nil
         
        protected
        
        def script_url(url)
          "#{url}"
        end
        
      end
    end
  end
end