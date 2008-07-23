module Salesforce
  module Interface
    attr_accessor :salesforce_session
    
    def salesforce
      if salesforce_session.nil?
        raise Salesforce::UnableToConnect unless acquire_salesforce_session
      end
      salesforce_session
    end
    
    def acquire_salesforce_session
      return true if reestablish_salesforce_session
      establish_salesforce_session
    rescue Salesforce::InvalidCredentials
      return false
    end
    
    def reestablish_salesforce_session
      return false if salesforce_url.nil?  || salesforce_session_id.nil? ||
                      salesforce_url == '' || salesforce_session_id == ''
      salesforce_session = Salesforce::Session.new salesforce_soap_url
      salesforce_session.test_connection
    rescue Salesforce::InvalidCredentials
      clear_salesforce_session
      return false
    end
    
    def establish_salesforce_session
      salesforce_session = nil
      salesforce_session = Salesforce::Session.new salesforce_soap_url
      salesforce_session.login salesforce_email, salesforce_authentication_string
      save_salesforce_session
    end
    
    def clear_salesforce_session
      salesforce_session = nil
      unsave_salesforce_session
    end

    def salesforce_authentication_string
      salesforce_password + salesforce_api_key
    end
    
    def salesforce_soap_url() 'https://www.salesforce.com/services/Soap/u/11.0' end
      
    define_method(:save_salesforce_session)   { true } unless respond_to? :save_salesforce_session
    define_method(:unsave_salesforce_session) { true } unless respond_to? :unsave_salesforce_session
    
  end
end