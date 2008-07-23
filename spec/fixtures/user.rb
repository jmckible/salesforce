# A class with persistance via ActiveRecord
class User < ActiveRecord::Base
  include Salesforce::Interface
  
  def save_salesforce_session
    update_attributes :salesforce_session_id=>salesforce.session_id, :salesforce_url=>salesforce.url.to_s
  end
  
  def unsave_salesforce_session
    update_attributes :salesforce_session_id=>nil, :salesforce_url=>nil
  end
end