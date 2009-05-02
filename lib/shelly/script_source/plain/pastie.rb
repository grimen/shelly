require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module ScriptSource
    module Plain
      class Pastie < Shelly::ScriptSource::Plain::Base
        
        SCRIPT_SOURCE_BASE_URL = 'pastie.org'.freeze
        
        protected
        
        def script_url(pastie_id)
          "http://#{SCRIPT_SOURCE_BASE_URL}/#{pastie_id}.txt"
        end
        
      end
    end
  end
end