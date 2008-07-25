require File.dirname(__FILE__) + '/helper'

describe Salesforce::Contact, 'Contact' do
  it 'should have a default' do
    Salesforce::Contact.query_string.should == "select AccountId, FirstName, LastName, Id, Email, Account.Id, Account.Name from Contact"
  end
end