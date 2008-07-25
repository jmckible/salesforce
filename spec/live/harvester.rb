# For pulling down XML examples as necessary

require File.dirname(__FILE__) + '/credentials'

describe 'harvester' do
  it 'should harvest' do
    person = Person.new :salesforce_email=>ENV['SF_EMAIL'], :salesforce_password=>ENV['SF_PASSWORD'], :salesforce_api_key=>ENV['SF_API_KEY']
    person.establish_salesforce_session.should be_true    
    #person.salesforce_session.contacts.find '0037000000UQb6wAAD'
    #person.salesforce_session.contacts.find_by_soql "select Id, FirstName, LastName, Email, AccountId, Account.Id, Account.name from Contact"
    #person.salesforce_session.campaigns.find :all
    #person.salesforce_session.campaigns.find_by_soql "select campaign.id, campaign.name, (select campaignmember.id, campaignmember.contactid, campaignmember.leadid from campaign.campaignmembers) from campaign where campaign.id = '701700000009QLhAAM'"
    person.salesforce_session.campaigns.find_by_soql "select Id, CampaignId, LeadId, Lead.Id, Lead.FirstName, Lead.LastName, Lead.Email, Lead.Company, ContactId, Contact.Id, Contact.FirstName, Contact.LastName, Contact.Email from CampaignMember where CampaignId = '701700000009QLhAAM'"
  end
end