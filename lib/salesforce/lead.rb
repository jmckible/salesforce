module Salesforce
  class Lead < Base
    
    attr_accessor :first_name, :last_name, :email
    
    class << self
      def columns
        {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email}
      end
    end
    
  end
end