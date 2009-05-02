require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'shelly'

class ShellyTest < Test::Unit::TestCase
  
  context "script source" do
    should "should be able to fetch: gist" do
      
    end
    
    should "should be able to fetch: pastebin" do
      
    end
    
    should "should be able to fetch: pastie" do
      
    end
    
    should "should be able to fetch: raw" do
      
    end
  end
  
  context "store" do
    # should "create config file in user root upon request" do
    #   `rm #{Shelly::Store::Base::CUSTOM_CONFIG_FILE_PATH}`
    #   Shelly.create!(:config)
    #   
    #   assert File.exist?(Shelly::Store::Base::CUSTOM_CONFIG_FILE_PATH)
    # end
    
    should "initialize config" do
      assert Shelly::Store::Base.load_config
    end
    
    should "be able to add alias to config" do
      Shelly.add(:alias, 'foo:http://pastie.org/12345')
      
      assert_equal Shelly::Store::Base.config['aliases']['foo'], 'http://pastie.org/12345'
    end
    
    should "be able to remove alias from config" do
      Shelly.add(:alias, 'foo:http://pastie.org/12345')
      Shelly.remove(:alias, 'foo')
      
      assert !Shelly::Store::Base.config['aliases'].keys.include?('foo')
    end
    
    should "be able to add repo to config" do
      Shelly.add(:repo, 'github/grimen/shelly')
      
      #flunk 'Not done testing yet.'
      
      #assert false
    end
    
    should "be able to remove repo from config" do
      Shelly.remove(:repo, 'github/grimen/shelly')
      
      #assert false
    end
  end
  
end