require File.dirname(__FILE__) + '/helper'

describe Salesforce::Account, 'columns' do
  it 'should have default id column' do
    Salesforce::Account.columns.should == {:Id=>:id, :Name=>:name}
  end
end