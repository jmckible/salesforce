module Salesforce
  class Lead < Base
    
    attr_accessor :first_name, :last_name, :email, :company
    
    class << self
      def columns
        {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :Company=>:company}
      end
    end
    
  end
end