raise 'Please provide a salesforce.yml credentials file for live specs' unless File.exists?(File.dirname(__FILE__) + '/salesforce.yml')

require File.dirname(__FILE__) + '/../helper'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/salesforce.yml'))
ENV['SF_EMAIL']    = config['email']
ENV['SF_PASSWORD'] = config['password']
ENV['SF_API_KEY']  = config['api_key']