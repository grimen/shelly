require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module ScriptSource
    module Plain
      class Raw < Shelly::ScriptSource::Plain::Base
        
        SCRIPT_SOURCE_BASE_URL = ''
         
        protected
        
        def script_url(url)
          "#{url}"
        end
        
      end
    end
  end
end