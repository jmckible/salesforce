# For pulling down XML examples as necessary

require File.dirname(__FILE__) + '/credentials'

describe 'harvester' do
  it 'should harvest' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.establish_salesforce_session.should be_true    
    leads = person.salesforce_session.leads.find :all
  end
end