require File.dirname(__FILE__) + '/helper'

describe Salesforce::Base, 'query string' do
  it 'should parse options' do
    Salesforce::Base.query_string.should == "select id from Base"
    Salesforce::Base.query_string(:select=>[:id, :name]).should == "select id, name from Base"
    Salesforce::Base.query_string(:conditions=>"id = 'id'").should == "select id from Base where id = 'id'"
  end
end

describe Salesforce::Base, 'parse results into collection' do
  it 'should create an empty collection'
  
  it 'should create a collection of one' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/account.xml')
    soap_response = Salesforce::SoapResponse.new xml
    
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:query).and_return(soap_response)
    
    collection = Salesforce::Account.find session, :select=>[:id, :name]
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 1
    collection.size.should == 1
  end
  
  it 'should create a collection of many' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/accounts.xml')
    soap_response = Salesforce::SoapResponse.new xml
    
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:query).and_return(soap_response)
    
    collection = Salesforce::Account.find session, :select=>[:id, :name]
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 6
    collection.size.should == 6
  end
  
  it 'should create a collection which is not done' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/leads.xml')
    soap_response = Salesforce::SoapResponse.new xml
    
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:query).and_return(soap_response)
    
    collection = Salesforce::Lead.find session, :select=>[:id, :firstname, :lastname]
    collection.class.should == Salesforce::Collection
    collection.should_not be_done
    collection.locator.should_not be_nil
    collection.total_results.should == 2
    collection.size.should == 2
  end
end

describe Salesforce::Base, 'initializing from a hash' do
  it 'should parse an account' do
    account = Salesforce::Base.initialize_from_hash :type=>'Account', :Name=>'name', :Id=>['id', 'id']
    account.class.should == Salesforce::Account
    account.name.should == 'name'
    account.id.should == 'id'
  end
end
