require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

require 'rubygems'

gem 'octopi', '0.0.9'
require 'octopi'

module Shelly
  module ScriptSource
    module Scm
      class Github < Shelly::ScriptSource::Scm::Base
        
        include Octopi
        
        SCRIPT_SOURCE_BASE_URL = 'http://github.com'.freeze
        
        def initialize(script_identifier)
          user_id, repo_name, file_name, commit_sha = id_parts = script_identifier.split('/')
          raise "Invalid script source: '#{script_identifier}'." unless id_parts.size >= 2
          
          self.fetch_url = self.script_url(user_id, repo_name, file_name, commit_sha)
          self.script_file_name = self.script_name(file_name)
          self.script_file_path = self.script_path(self.script_file_name)
        end
        
        protected
        
        def script_url(user_id, repo_name, file_name, commit_sha = nil)
          commit_sha ||= Repository.find(user_id, repo_name).commits.first.id
          "#{SCRIPT_SOURCE_BASE_URL}/#{user_id}/#{repo_name}/raw/#{commit_sha}/#{file_name}"
        end
        
      end
    end
  end
end