require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

require 'uri'

module Shelly
  module ScriptSource
    module Plain
      class Raw < Shelly::ScriptSource::Plain::Base
        
        SCRIPT_SOURCE_BASE_URL = '.'.freeze
        
        protected
        
        def script_url(url)
          URI.encode("#{url}")
        end
        
      end
    end
  end
end