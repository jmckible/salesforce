require File.dirname(__FILE__) + '/helper'

describe 'like query' do
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
    Salesforce::Base.should_receive(:find).with(@session, :all, :conditions=>nil)
    Salesforce::Base.like(@session, 'query')
  end
  
  it 'should pass through order clause even if name is not a known attribute' do
    Salesforce::Base.should_receive(:find).with(@session, :all, :order=>:id, :conditions=>nil)
    Salesforce::Base.like(@session, 'query', :order=>:id)
  end
  
  it 'should just do a find if no string passed' do
    Salesforce::Account.should_receive(:find).with(@session, :all, :conditions=>nil, :order=>:name)
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
    Salesforce::Base.should_receive(:find).with(@session, :all, :conditions=>nil)
    Salesforce::Base.like(@session, 'query', :on=>:name)
  end
  
  it 'should append a condition clause' do
    Salesforce::Lead.should_receive(:find).with(@session, :all, :conditions=>"AccountId = 'id' and Name like '%query%'", :order=>:name)
    Salesforce::Lead.like(@session, 'query', :conditions=>"AccountId = 'id'")
  end
end