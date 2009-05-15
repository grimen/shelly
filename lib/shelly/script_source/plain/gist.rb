require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

module Shelly
  module ScriptSource
    module Plain
      class Gist < Shelly::ScriptSource::Plain::Base
        
        SCRIPT_SOURCE_BASE_URL = 'gist.github.com'.freeze
        
        protected
        
        def script_url(gist_id)
          "http://#{SCRIPT_SOURCE_BASE_URL}/#{gist_id}.txt"
        end
        
      end
    end
  end
end