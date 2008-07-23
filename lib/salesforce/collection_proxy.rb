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
    
  end
end