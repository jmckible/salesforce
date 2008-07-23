require File.dirname(__FILE__) + '/helper'

describe Salesforce::Collection, 'initialization' do
  it 'should initialize as done' do
    Salesforce::Collection.new.should be_done
  end
  
  it 'should initialize with 0 total results' do
    Salesforce::Collection.new.total_results.should == 0
  end
end