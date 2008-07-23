require File.dirname(__FILE__) + '/helper'

describe 'universal interface methods' do
  before(:each) do
    @person = Person.new
  end
  
  it 'should have an authentication string' do
    @person.salesforce_password = 'password'
    @person.salesforce_api_key  = 'apikey'
    @person.salesforce_authentication_string.should == 'passwordapikey'
  end
end

describe 'acquiring a session' do
  before(:each) do
    @person = Person.new
  end
  
  it 'should raise an exception if cannot acquire' do
    @person.stub!(:acquire_salesforce_session).and_return(false)
    lambda { @person.salesforce }.should raise_error(Salesforce::UnableToConnect)
  end
  
  it 'should return the session if can acquire' do
    session = mock 'session'
    @person.salesforce_session = session
    @person.stub!(:acquire_salesforce_session).and_return(true)
    @person.salesforce.should == session
  end
end

describe Person, 'using generic class' do
  before(:each) do
    @person = Person.new
  end
  
  it 'should use the default attributes' do
    @person.salesforce_email.should    == ''
    @person.salesforce_password.should == ''
    @person.salesforce_api_key.should  == ''
  end
  
  it 'should use the default session persistance method' do
    @person.save_salesforce_session.should be_true
  end
  
  it 'should use the default session de-persistance method' do
    @person.unsave_salesforce_session.should be_true
  end
  
  it 'should have a default soap path' do
    @person.salesforce_soap_url.should =~ /https:\/\/www.salesforce.com\/services\/Soap\/u\//
  end
end

describe User, 'using Salesforce via ActiveRecord' do 
  before(:each) do
    @user = User.new :salesforce_email=>'email@address.com', :salesforce_password=>'password', :salesforce_api_key=>'api key'
  end
  
  it 'should use the database attributes' do
    @user.salesforce_email.should    == 'email@address.com'
    @user.salesforce_password.should == 'password'
    @user.salesforce_api_key.should  == 'api key'
  end
  
  it 'should override the session persistance method' do
    salesforce = mock 'salesforce', :session_id=>'session id', :url=>'url'
    @user.stub!(:salesforce).and_return(salesforce)
    @user.should_receive(:update_attributes).with({:salesforce_session_id=>'session id', :salesforce_url=>'url'})
    @user.save_salesforce_session
  end
  
  it 'should override the session de-persistance method' do
    @user.should_receive(:update_attributes).with({:salesforce_session_id=>nil, :salesforce_url=>nil})
    @user.unsave_salesforce_session
  end
end