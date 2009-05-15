require File.expand_path(File.join(File.dirname(__FILE__), '..', 'base'))

module Shelly
  module ScriptSource
    module Plain
      class Base < Shelly::ScriptSource::Base
        
        protected
        
        def is_url(url)
          url =~ /#{SCRIPT_SOURCE_BASE_URL}/
        end
        
      end
    end
  end
end