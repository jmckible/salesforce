require File.dirname(__FILE__) + '/helper'

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