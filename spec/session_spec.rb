require File.dirname(__FILE__) + '/helper'

describe Salesforce::Session, 'proxying' do
  it 'should have an account proxy' do
    session = Salesforce::Session.new 'https://www.salesforce.com/services/Soap/u/11.0'
    session.accounts.class.should == Salesforce::CollectionProxy
    session.accounts.session.should == session
    session.accounts.klass.should == Salesforce::Account
  end
end