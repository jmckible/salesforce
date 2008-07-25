module Salesforce
  class CampaignMember < Base
    
    attr_accessor :campaign_id, :contact_id, :lead_id, :contact, :lead
    
    class << self
      def columns
        {:Id=>:id, :CampaignId=>:campaign_id, :ContactId=>:contact_id, :LeadId=>:lead_id}
      end
    
      def belongs_to
        {Salesforce::Contact=>:contact, Salesforce::Lead=>:lead}
      end
    end
    
    def person
      contact || lead
    end
    
  end
end
    