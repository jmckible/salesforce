module Salesforce
  class Account < Base
    attr_accessor :name
    
    class << self
      def columns
        {:Id=>:id, :Name=>:name}
      end
    end
    
  end
end