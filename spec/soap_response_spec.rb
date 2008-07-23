require File.dirname(__FILE__) + '/helper'

describe Salesforce::SoapResponse, 'parsing' do
  it 'should handle an error response'
  
  it 'should build a response from an empty result'
  
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
  
  it 'should build a response from a result which is not done'
end