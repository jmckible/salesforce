module Salesforce
  class Campaign < Base
    
    attr_accessor :name, :number_of_contacts, :number_of_leads, :description
    
    class << self
      def columns
        {:Id=>:id, :Name=>:name, :NumberOfContacts=>:number_of_contacts, :NumberOfLeads=>:number_of_leads, :Description=>:description}
      end
    end
    
    def size
      (@number_of_contacts.to_i || 0) + (@number_of_leads.to_i || 0)
    end
    
  end
end