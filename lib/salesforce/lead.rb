module Salesforce
  class Lead < Base
    
    attr_accessor :first_name, :last_name, :email
    
    def firstname=(name)
      @first_name = name
    end
    
    def lastname=(name)
      @last_name = name
    end
    
  end
end