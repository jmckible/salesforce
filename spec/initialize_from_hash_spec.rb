require File.dirname(__FILE__) + '/helper'

describe 'initializing from a hash' do
  it 'should parse an account' do
    account = Salesforce::Base.initialize_from_hash :type=>'Account', :Name=>'name', :Id=>['id', 'id']
    account.class.should == Salesforce::Account
    account.name.should == 'name'
    account.id.should == 'id'
  end
  
  it 'should skip an unknown' do
    Salesforce::Base.initialize_from_hash(:type=>'Unknown').should be_nil
  end
end