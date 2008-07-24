module Salesforce
  class Base
    
    attr_accessor :id
    
    def self.find(session, args)
      if args.is_a?(String)
        find_one session, args
      else # Hash
        find_every session, args
      end
    end
    
    def self.find_every(session, options)
      response = session.query :queryResponse=>query_string(options)
      
      collection = Salesforce::Collection.new 
      
      records = response.queryResponse.result.records
      records = [records] unless records.is_a?(Array)
      records.each { |r| collection << initialize_from_hash(r) }
      
      collection.total_results = response.queryResponse.result[:size].to_i
      collection.done = false if response.queryResponse.result.done == 'false'
      collection.locator = response.queryResponse.result[:queryLocator] if response.queryResponse.result[:queryLocator]
      
      collection
    end
    
    def self.query_string(options={})
      columns    = (options[:select] || [:id]).join ', '
      conditions = options[:conditions]
      base = "select #{columns} from #{table_name}"
      base += " where #{conditions}" if conditions
      base
    end
    
    def self.initialize_from_hash(hash)
      if hash[:type] == 'Account'
        object = Salesforce::Account.new
      elsif hash[:type] == 'Lead'
        object = Salesforce::Lead.new
      end
      hash.each do |pair|
        unless pair[0] == :type || pair[0] == :Id
          attribute = pair[0].to_s.tr("-", "_").
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            downcase
          
          object.__send__("#{attribute}=", pair[1]) if object.respond_to?("#{attribute}=")
        end
      end
      object.id = hash[:Id].first
      object
    end
    
    def self.table_name
      name.split('::').last
    end
    
  end
end