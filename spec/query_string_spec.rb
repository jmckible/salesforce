require File.dirname(__FILE__) + '/helper'

describe 'query string' do
  it 'should have a default' do
    Salesforce::Base.query_string.should == "select Id from Base"
  end
  
  it 'should reject unknown columns on select' do
    Salesforce::Base.query_string(:select=>[:id, :name]).should == "select Id from Base"
  end
  
  it 'should take a non array as a select' do
    Salesforce::Account.query_string(:select=>:name).should == "select Name from Account"
  end
  
  it 'should add conditions' do
    Salesforce::Base.query_string(:conditions=>"1 = 1").should == "select Id from Base where 1 = 1"
  end
  
  it 'should ignore nil conditions' do
    Salesforce::Base.query_string(:conditions=>nil).should == "select Id from Base"
  end
  
  it 'should handle order clause' do
    Salesforce::Base.query_string(:order=>'name').should == "select Id from Base order by name"
    Salesforce::Account.query_string(:order=>:name).should == "select Id, Name from Account order by Name"
    Salesforce::Base.query_string(:order=>:name).should == "select Id from Base"
  end
end