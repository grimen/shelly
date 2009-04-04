module Shelly
  module ScriptSource
    module Plain
      class Gist < Shelly::ScriptSource::Base
        
        SCRIPT_SOURCE_BASE_URL = 'http://gist.github.com'.freeze
        
        protected
        
        def script_url(gist_id)
          "#{SCRIPT_SOURCE_BASE_URL}/#{gist_id}.txt"
        end
        
      end
    end
  end
end