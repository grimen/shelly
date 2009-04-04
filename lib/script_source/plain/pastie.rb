module Shelly
  module ScriptSource
    module Plain
      class Pastie < Shelly::ScriptSource::Base
        
        SCRIPT_SOURCE_BASE_URL = 'http://pastie.org'.freeze
        
        protected
        
        def script_url(pastie_id)
          "#{SCRIPT_SOURCE_BASE_URL}/#{pastie_id}.txt"
        end
        
      end
    end
  end
end