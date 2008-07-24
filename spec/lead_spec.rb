require File.dirname(__FILE__) + '/helper'

describe Salesforce::Lead, 'columns' do
  it 'should have default id column' do
    Salesforce::Lead.columns.should == {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :Company=>:company}
  end
end