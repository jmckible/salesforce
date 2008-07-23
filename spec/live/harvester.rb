# For pulling down XML examples as necessary

require File.dirname(__FILE__) + '/credentials'

describe 'harvester' do
  it 'should pull down leads' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.salesforce.leads.find :all, :select=>[:id, :firstName, :lastName] 
  end
end