require File.dirname(__FILE__) + '/credentials'

describe Person, '(live account query)' do
  it 'should find all the accounts' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.establish_salesforce_session.should be_true    
    accounts = person.salesforce_session.accounts.find :all
    accounts.size.should == 9
  end
  
  it 'should find a single lead' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.establish_salesforce_session.should be_true    
    lead = person.salesforce_session.leads.find '00Q7000000MnYrAEAV'
    lead.first_name.should == 'Joe'
    lead.last_name.should == 'Bob697'
    lead.email.should == 'hashito2010@yahoo.com'
    lead.id.should == '00Q7000000MnYrAEAV'
  end
end