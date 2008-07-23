# Any old class
class Person
  include Salesforce::Interface
  
  attr_accessor :salesforce_email, :salesforce_password, :salesforce_api_key
  def initialize
    @salesforce_email    = ''
    @salesforce_password = ''
    @salesforce_api_key  = ''
  end
  
end