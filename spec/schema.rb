ActiveRecord::Schema.define(:version=>0) do
  
  create_table :users, :force=>true do |t|
    t.string 'salesforce_sesssion_id'
    t.string 'salesforce_url'
    t.string 'salesforce_email'
    t.string 'salesforce_api_key'
    t.string 'salesforce_password'
  end
  
end