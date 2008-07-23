require File.dirname(__FILE__) + '/credentials'

describe Salesforce::Session do
  before(:all) do
    @email    = ENV['SF_EMAIL']
    @password = ENV['SF_PASSWORD']
    @api_key  = ENV['SF_API_KEY']
    
    @session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
  end
  
  it 'initialize parameters' do
    @session.url.to_s.should == 'https://www.salesforce.com/services/Soap/u/11.0'
    @session.batch_size.should == 20
    @session.session_id.should be_nil
  end
  
  it 'should login' do
    response = @session.login @email, (@password + @api_key)
    response.should_not be_nil
    # Change the url
    @session.url.to_s.should_not == 'https://www.salesforce.com/services/Soap/u/11.0'
  end
  
  it 'should raise exception on invalid credentials' do
    lambda { @session.login @email, 'fake' }.should raise_error(Salesforce::InvalidCredentials)
  end
  
  it 'should test connection' do
    @session.login @email, (@password + @api_key)
    @session.test_connection.should_not be_nil
  end
end