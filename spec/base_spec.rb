require File.dirname(__FILE__) + '/helper'

###############################################################################
#                               C O L U M N S                                 #
###############################################################################
describe Salesforce::Base, 'columns' do
  it 'should have a class level columns hash' do
    Salesforce::Base.columns.should == {:Id=>:id}
    Salesforce::Account.columns.should == {:Id=>:id, :Name=>:name}
    Salesforce::Base.columns.should == {:Id=>:id}
  end
end

###############################################################################
#                          Q U E R Y    S T R I N G                           #
###############################################################################
describe Salesforce::Base, 'query string' do
  it 'should have a default' do
    Salesforce::Base.query_string.should == "select Id from Base"
  end
  
  it 'should reject unknown columns on select' do
    Salesforce::Base.query_string(:select=>[:id, :name]).should == "select Id from Base"
  end
  
  it 'should take a non array as a select' do
    Salesforce::Account.query_string(:select=>:name).should == "select Name from Account"
  end
  
  it 'should handle conditions' do
    Salesforce::Base.query_string(:conditions=>"1 = 1").should == "select Id from Base where 1 = 1"
  end
  
  it 'should handle order clause' do
    Salesforce::Base.query_string(:order=>'name').should == "select Id from Base order by name"
    Salesforce::Account.query_string(:order=>:name).should == "select Id, Name from Account order by Name"
    Salesforce::Base.query_string(:order=>:name).should == "select Id from Base"
  end
end

###############################################################################
#                                      F I N D                                #
###############################################################################
describe Salesforce::Base, 'finding' do
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

###############################################################################
#                                   L I K E                                   #
###############################################################################
describe Salesforce::Base, 'like query' do
  def stub_session(filename)
    soap_response = Salesforce::SoapResponse.new IO.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.stub!(:query).and_return(soap_response)
    session
  end
  
  before(:all) do
    @session = stub_session 'accounts.xml'
  end
  
  it 'should do a find on the name' do
    Salesforce::Account.should_receive(:find).with(@session, :all, :conditions=>"Name like '%query%'", :order=>:name)
    Salesforce::Account.like(@session, 'query')
  end
  
  it 'should overwrite the order by clause' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>"Name like '%query%'", :order=>:first_name)
    Salesforce::Lead.like(nil, 'query', :order=>:first_name)
  end
  
  it 'should just do a find if no name attribute' do
    Salesforce::Base.should_receive(:find).with(@session, :all)
    Salesforce::Base.like(@session, 'query')
  end
  
  it 'should pass through order clause even if name is not a known attribute' do
    Salesforce::Base.should_receive(:find).with(@session, :all, :order=>:id)
    Salesforce::Base.like(@session, 'query', :order=>:id)
  end
  
  it 'should just do a find if no string passed' do
    Salesforce::Account.should_receive(:find).with(@session, :all, :order=>:name)
    Salesforce::Account.like(@session, '')
  end
  
  it 'should overwrite the Name column with a known column' do
    Salesforce::Lead.should_receive(:find).with(@session, :all, :conditions=>"FirstName like '%query%'", :order=>:first_name)
    Salesforce::Lead.like(@session, 'query', :on=>:first_name)
  end
  
  it 'should overwrite the Name column with a known column and preserve order' do
    Salesforce::Lead.should_receive(:find).with(@session, :all, :conditions=>"FirstName like '%query%'", :order=>:id)
    Salesforce::Lead.like(@session, 'query', :on=>:first_name, :order=>:id)
  end
  
  it 'should handle overwriting the name column with an unknown column' do
    Salesforce::Base.should_receive(:find).with(@session, :all)
    Salesforce::Base.like(@session, 'query', :on=>:name)
  end
end


###############################################################################
#                 I N I T I A L I Z E    F R O M    H A S H                   #
###############################################################################
describe Salesforce::Base, 'initializing from a hash' do
  it 'should parse an account' do
    account = Salesforce::Base.initialize_from_hash :type=>'Account', :Name=>'name', :Id=>['id', 'id']
    account.class.should == Salesforce::Account
    account.name.should == 'name'
    account.id.should == 'id'
  end
  
  it 'should skip an unknown' do
    Salesforce::Base.initialize_from_hash(:type=>'Unknown').should be_nil
  end
end

###############################################################################
#                             I N I T I A L I Z E                             #
###############################################################################
describe Salesforce::Base, 'initialize' do
  it 'should assign variables' do
    lead = Salesforce::Lead.new :first_name=>'First', :last_name=>'Last'
    lead.first_name.should == 'First'
    lead.last_name.should == 'Last'
  end
  
  it 'should skip unknown values' do
    base = Salesforce::Base.new :id=>'id', :name=>'fake'
    base.id.should == 'id'
  end
end