require File.dirname(__FILE__) + '/helper'

describe Salesforce::Contact, 'columns' do
  it 'should have default id column' do
    Salesforce::Contact.columns.should == {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :AccountId=>:account_id, :Name=>:name}
  end
end

describe Salesforce::Contact, 'name' do
  it 'should retreive a name' do
    contact = Salesforce::Contact.new :first_name=>'First', :last_name=>'Last'
    contact.name.should == 'First Last'
  end
  
  it 'should retreive a nil name' do
    Salesforce::Contact.new.name.should == ''
  end
  
  it 'should set a nil name' do
    contact = Salesforce::Contact.new :name=>nil
    contact.name.should == ''
    contact.first_name.should be_nil
    contact.last_name.should be_nil
  end
  
  it 'should set an empty name' do
    contact = Salesforce::Contact.new :name=>''
    contact.name.should == ''
    contact.first_name.should be_nil
    contact.last_name.should == ''
  end
  
  it 'should set a name' do
    contact = Salesforce::Contact.new :name=>'Joe Bob'
    contact.name.should == 'Joe Bob'
    contact.first_name.should == 'Joe'
    contact.last_name.should == 'Bob'
  end
  
  it 'should set a name with many parts' do
    contact = Salesforce::Contact.new :name=>'Joe Bob Smith'
    contact.name.should == 'Joe Bob Smith'
    contact.first_name.should == 'Joe'
    contact.last_name.should == 'Bob Smith'
  end
end