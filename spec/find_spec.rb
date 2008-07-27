require File.dirname(__FILE__) + '/helper'

describe 'find' do
  def stub_session(filename)
    soap_response = Salesforce::SoapResponse.new IO.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:query).and_return(soap_response)
    session
  end
  
  it 'should handle a malformed query' do
    session = stub_session 'malformed.xml'    
    lambda { 
      Salesforce::Account.find session, :all 
    }.should raise_error(Salesforce::InvalidParameters)
  end
  
  it 'should create an empty collection' do
    session = stub_session 'empty.xml'
    collection = Salesforce::Account.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 0
    collection.size.should == 0
  end
  
  it 'should create a collection of one' do
    session = stub_session 'account.xml'
    collection = Salesforce::Account.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 1
    collection.size.should == 1
  end
  
  it 'should create a collection of many' do
    session = stub_session 'accounts.xml'
    collection = Salesforce::Account.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 6
    collection.size.should == 6
  end
  
  it 'should create a collection of many with belongs_to' do
    session = stub_session 'contacts.xml'
    
    collection = Salesforce::Contact.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 2
    collection.size.should == 2
    
    contact = collection.first
    contact.first_name.should == 'Stella'
    contact.last_name.should == 'Pavlova'
    contact.id.should == '0037000000UQb6wAAD'
    contact.email.should == 'stella@pavlova.com'
    contact.account_id.should == '0017000000Mk5RMAAZ'
    contact.account.class.should == Salesforce::Account
    contact.account.id.should == contact.account_id
    contact.account.name.should == 'United Oil Gas Corp.'
  end
  
  it 'should create a collection of many with multiple belongs_to' do
    session = stub_session 'campaign_members.xml'
    
    collection = Salesforce::CampaignMember.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 2
    collection.size.should == 2
    
    contact = collection.first.person
    lead = collection.last.person
    
    contact.class.should == Salesforce::Contact
    contact.first_name.should == 'Lauren'
    contact.last_name.should == 'Boyle'
    contact.id.should == '0037000000UQb6xAAD'
    contact.email.should == 'lauren@boyle.com'

    lead.class.should == Salesforce::Lead
    lead.first_name.should == 'Liz'
    lead.last_name.should == 'Cruz'
    lead.id.should == '0037000000UQb74AAD'
    lead.email.should == 'liz@cruz.com'
  end
  
  it 'should query with soql' do
    session = stub_session 'accounts.xml'
    collection = Salesforce::Account.find_by_soql session, "select Id, Name from Account"
    collection.class.should == Salesforce::Collection
    collection.should be_done
    collection.locator.should be_nil
    collection.total_results.should == 6
    collection.size.should == 6
  end
  
  it 'should create a collection which is not done' do
    session = stub_session 'leads.xml'
    collection = Salesforce::Lead.find session, :all
    collection.class.should == Salesforce::Collection
    collection.should_not be_done
    collection.locator.should_not be_nil
    collection.total_results.should == 3400
    collection.size.should == 2
  end
  
  it 'should find the first record' do
    session = stub_session 'leads.xml'
    lead = Salesforce::Lead.find session, :first
    lead.class.should == Salesforce::Lead
    lead.id.should == '00Q7000000MnYrAEAV'
    lead.first_name.should == 'Joe'
    lead.last_name.should == 'Bob'
    lead.email.should == 'joe@bob.com'
  end
  
  it 'should find the last record' do
    session = stub_session 'leads.xml'
    lead = Salesforce::Lead.find session, :last
    lead.class.should == Salesforce::Lead
    lead.id.should == '00Q7000000MnYrBEAV'
    lead.first_name.should == 'Bob'
    lead.last_name.should == 'Joe'
    lead.email.should == 'bob@joe.com'
  end
  
  it 'should find a record by id' do
    session = stub_session 'account.xml'
    account = Salesforce::Account.find session, '0017000000Mk5RKAAZ'
    account.class.should == Salesforce::Account
    account.id.should == '0017000000Mk5RKAAZ'
    account.name.should == 'Express Logistics and Transport'
  end
  
  it 'should find a locator record' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/locator.xml')
    soap_response = Salesforce::SoapResponse.new xml
    
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:queryMore).and_return(soap_response)
    
    collection = Salesforce::Lead.find session, :locator, :id=>'01g70000002cRQJAA2-200'
    collection.class.should == Salesforce::Collection
    collection.should_not be_done
    collection.locator.should_not be_nil
    collection.total_results.should == 3400
    collection.size.should == 2
  end
end