require File.dirname(__FILE__) + '/helper'

describe Salesforce::SoapResponse, 'parsing' do
  it 'should handle a valid query locator' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/locator.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response.queryMoreResponse.result.done.should == 'false'
    soap_response.queryMoreResponse.result[:queryLocator].should_not be_nil
    soap_response.queryMoreResponse.result[:size].should == '3400'
    soap_response.queryMoreResponse.result.records.size.should == 2
    
    lead = soap_response.queryMoreResponse.result.records.first
    lead[:type].should == 'Lead'
    lead[:FirstName].should == 'Joe'
    lead[:LastName].should == 'Bob'
    lead[:Email].should == 'joe@bob.com'
    lead[:Id].first.should == '00Q7000000MnYl1EAF'
  end
  
  it 'should handle an invalid query locator' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/invalid_locator.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response[:Fault].should_not be_nil
  end
  
  it 'should handle a malformed response' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/malformed.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response[:Fault].should_not be_nil
  end
  
  it 'should build a response from an empty result' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/empty.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response.queryResponse.result.done.should == 'true'
    soap_response.queryResponse.result[:queryLocator].should be_nil
    soap_response.queryResponse.result[:size].should == '0'
  end
  
  it 'should build a response from single result' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/account.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response.queryResponse.result.done.should == 'true'
    soap_response.queryResponse.result[:queryLocator].should be_nil
    soap_response.queryResponse.result[:size].should == '1'
    soap_response.queryResponse.result.records.should be_is_a(Hash)
    
    account = soap_response.queryResponse.result.records
    account[:type].should == 'Account'
    account[:Name].should == 'Express Logistics and Transport'
    account[:Id].first.should == '0017000000Mk5RKAAZ'
  end
  
  it 'should build a response from many results' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/accounts.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response.queryResponse.result.done.should == 'true'
    soap_response.queryResponse.result[:queryLocator].should be_nil
    soap_response.queryResponse.result[:size].should == '6'
    soap_response.queryResponse.result.records.size.should == 6
    
    account = soap_response.queryResponse.result.records.first
    account[:type].should == 'Account'
    account[:Name].should == 'Express Logistics and Transport'
    account[:Id].first.should == '0017000000Mk5RKAAZ'
  end
  
  it 'should build a response from a result which is not done' do
    xml = IO.read(File.dirname(__FILE__) + '/fixtures/leads.xml')
    soap_response = Salesforce::SoapResponse.new xml
    soap_response.queryResponse.result.done.should == 'false'
    soap_response.queryResponse.result[:queryLocator].should_not be_nil
    soap_response.queryResponse.result[:size].should == '3400'
    soap_response.queryResponse.result.records.size.should == 2
    
    lead = soap_response.queryResponse.result.records.first
    lead[:type].should == 'Lead'
    lead[:FirstName].should == 'Joe'
    lead[:LastName].should == 'Bob'
    lead[:Email].should == 'joe@bob.com'
    lead[:Id].first.should == '00Q7000000MnYrAEAV'
  end
end