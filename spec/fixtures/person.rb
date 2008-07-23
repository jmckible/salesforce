# Any old class
class Person
  include Salesforce::Interface
  
  attr_accessor :salesforce_email, :salesforce_password, :salesforce_api_key,
    :salesforce_url, :salesforce_session_id
  
  def initialize(params={})
    params.each { |p| __send__ "#{p[0]}=", p[1] }
  end
  
end