require File.dirname(__FILE__) + '/credentials'

describe Person, '(live account query)' do
  it 'should find all the accounts' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.establish_salesforce_session.should be_true    
    accounts = person.salesforce_session.accounts.find :select=>[:id, :name]
    accounts.size.should == 9
  end
end