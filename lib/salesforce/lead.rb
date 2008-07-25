module Salesforce
  class Lead < Base
    
    attr_accessor :first_name, :last_name, :email, :company
    
    class << self
      def columns
        {:Id=>:id, :FirstName=>:first_name, :LastName=>:last_name, :Email=>:email, :Company=>:company, :Name=>:name}
      end
    end
    
    def name
      [@first_name, @last_name].compact.join ' '
    end
    
    def name=(name)
      return name if name.nil?
      parts = name.split ' '
      @first_name = parts.shift
      @last_name = parts.join ' '
      name
    end
    
  end
end