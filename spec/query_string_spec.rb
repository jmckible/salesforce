require File.dirname(__FILE__) + '/helper'

describe 'query string' do
  it 'should have a default' do
    Salesforce::Base.query_string.should == "SELECT Id FROM Base"
  end
  
  it 'should reject unknown columns on select' do
    Salesforce::Base.query_string(:select=>[:id, :name]).should == "SELECT Id FROM Base"
  end
  
  it 'should take a non array as a select' do
    Salesforce::Account.query_string(:select=>:name).should == "SELECT Name FROM Account"
  end
  
  it 'should add conditions' do
    Salesforce::Base.query_string(:conditions=>"1 = 1").should == "SELECT Id FROM Base WHERE 1 = 1"
  end
  
  it 'should escape conditions'
  
  it 'should ignore nil conditions' do
    Salesforce::Base.query_string(:conditions=>nil).should == "SELECT Id FROM Base"
  end
  
  it 'should handle order clause' do
    Salesforce::Base.query_string(:order=>'name').should == "SELECT Id FROM Base ORDER BY name"
    Salesforce::Account.query_string(:order=>:name).should == "SELECT Id, Name FROM Account ORDER BY Name"
    Salesforce::Base.query_string(:order=>:name).should == "SELECT Id FROM Base"
  end
end