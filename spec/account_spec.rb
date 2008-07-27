require File.dirname(__FILE__) + '/helper'

describe Salesforce::Account, 'columns' do
  it 'should have id and name mappings' do
    Salesforce::Account.columns.should == {:Id=>:id, :Name=>:name}
  end
end