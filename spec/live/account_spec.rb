require File.dirname(__FILE__) + '/credentials'

describe Salesforce::Account, 'live query' do
  before(:all) do
    @email    = ENV['SF_EMAIL']
    @password = ENV['SF_PASSWORD']
    @api_key  = ENV['SF_API_KEY']
    
    @session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    @session.login @email, (@password + @api_key)
  end
end