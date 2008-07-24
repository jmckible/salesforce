module Salesforce
  class Contact < Base
    
    attr_accessor :first_name, :last_name, :email, :account_id
    
    class << self
      def columns
        {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :AccountId=>:account_id}
      end
    end
    
  end
end