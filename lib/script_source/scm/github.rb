module Shelly
  module ScriptSource
    module Scm
      class Github < Shelly::ScriptSource::Base
        
        SCRIPT_SOURCE_BASE_URL = 'http://github.com'.freeze
        
        def initialize(script_identifier)
          user, repo, file, version = script_identifier.split('/')
          # puts user, repo, file, version
          puts self.fetch_url = self.script_url(user, repo, file, version)
          self.script_file_name = self.script_name(file)
          self.script_file_path = self.script_path(self.script_file_name)
        end
        
        protected
        
        def script_url(user, repo, file, version)
          "#{SCRIPT_SOURCE_BASE_URL}/#{user}/#{repo}/raw/#{version}/#{file}"
        end
        
      end
    end
  end
end