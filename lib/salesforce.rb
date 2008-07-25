$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Salesforce
  class SalesforceError < StandardError
  end
  
  class InvalidCredentials < SalesforceError
  end
  
  class InvalidSession < SalesforceError
  end
  
  class UnableToConnect < SalesforceError
  end
  
  class InvalidParameters < SalesforceError
  end
end

require 'net/https'
require 'uri'
require 'zlib'
require 'stringio'
require 'rexml/document'
require 'rexml/xpath'
require 'rubygems'
require 'builder'

require 'salesforce/base'

require 'salesforce/account'
require 'salesforce/campaign'
require 'salesforce/collection'
require 'salesforce/collection_proxy'
require 'salesforce/contact'
require 'salesforce/interface'
require 'salesforce/lead'
require 'salesforce/session'
require 'salesforce/soap_response'