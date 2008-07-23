module Salesforce
  class Collection < Array
    
    attr_accessor :total_results, :done, :locator
    
    def initialize
      @total_results = 0
      @done          = true
    end
    
    def done?
      @done
    end
    
  end
end