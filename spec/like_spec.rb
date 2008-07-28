require File.dirname(__FILE__) + '/helper'

describe 'like query' do
  
  it 'should do a find on the name' do
    Salesforce::Account.should_receive(:find).with(nil, :all, :conditions=>["Name LIKE ?", '%query%'], :order=>:name)
    Salesforce::Account.like(nil, 'query')
  end
  
  it 'should overwrite the order by clause' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>["Name LIKE ?", '%string%'], :order=>:first_name)
    Salesforce::Lead.like(nil, 'string', :order=>:first_name)
  end
  
  it 'should just do a find if no name attribute' do
    Salesforce::Base.should_receive(:find).with(nil, :all, {})
    Salesforce::Base.like(nil, 'query')
  end
  
  it 'should pass through order clause even if name is not a known attribute' do
    Salesforce::Base.should_receive(:find).with(nil, :all, :order=>:id)
    Salesforce::Base.like(nil, 'query', :order=>:id)
  end
  
  it 'should just do a find if no string passed' do
    Salesforce::Account.should_receive(:find).with(nil, :all, :order=>:name)
    Salesforce::Account.like(nil, '')
  end
  
  it 'should overwrite the Name column with a known column' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>["FirstName LIKE ?", '%query%'], :order=>:first_name)
    Salesforce::Lead.like(nil, 'query', :on=>:first_name)
  end
  
  it 'should overwrite the Name column with a known column and preserve order' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>["FirstName LIKE ?", '%query%'], :order=>:id)
    Salesforce::Lead.like(nil, 'query', :on=>:first_name, :order=>:id)
  end
  
  it 'should handle overwriting the name column with an unknown column' do
    Salesforce::Base.should_receive(:find).with(nil, :all, {})
    Salesforce::Base.like(nil, 'query', :on=>:name)
  end
  
  it 'should append a condition clause with a string' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>["AccountId = 'id' AND Name LIKE ?", '%query%'], :order=>:name)
    Salesforce::Lead.like(nil, 'query', :conditions=>"AccountId = 'id'")
  end
  
  it 'should append a condition clause with an array' do
    Salesforce::Lead.should_receive(:find).with(nil, :all, :conditions=>["AccountId = ? AND Name LIKE ?", 'id', '%q%'], :order=>:name)
    Salesforce::Lead.like(nil, 'q', :conditions=>["AccountId = ?", 'id'])
  end
end