require File.dirname(__FILE__) + '/helper'

describe Salesforce::Lead, 'columns' do
  it 'should have default id column' do
    Salesforce::Lead.columns.should == {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :Company=>:company, :Name=>:name}
  end
end

describe Salesforce::Lead, 'name' do
  it 'should retreive a name' do
    lead = Salesforce::Lead.new :first_name=>'First', :last_name=>'Last'
    lead.name.should == 'First Last'
  end
  
  it 'should retreive a nil name' do
    Salesforce::Lead.new.name.should == ''
  end
  
  it 'should set a nil name' do
    lead = Salesforce::Lead.new :name=>nil
    lead.name.should == ''
    lead.first_name.should be_nil
    lead.last_name.should be_nil
  end
  
  it 'should set an empty name' do
    lead = Salesforce::Lead.new :name=>''
    lead.name.should == ''
    lead.first_name.should be_nil
    lead.last_name.should == ''
  end
  
  it 'should set a name' do
    lead = Salesforce::Lead.new :name=>'Joe Bob'
    lead.name.should == 'Joe Bob'
    lead.first_name.should == 'Joe'
    lead.last_name.should == 'Bob'
  end
  
  it 'should set a name with many parts' do
    lead = Salesforce::Lead.new :name=>'Joe Bob Smith'
    lead.name.should == 'Joe Bob Smith'
    lead.first_name.should == 'Joe'
    lead.last_name.should == 'Bob Smith'
  end
end