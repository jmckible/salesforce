module Salesforce
  class CollectionProxy
    
    attr_accessor :session, :klass
    def initialize(session, klass)
      @session = session
      @klass   = klass
    end
    
    def find(*options)
      klass.find session, *options
    end
    
    def find_by_soql(query)
      klass.find_by_soql session, query
    end
    
    def like(*options)
      klass.like session, *options
    end
    
  end
end