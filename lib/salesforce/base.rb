module Salesforce
  class Base
    attr_accessor :id
    
    def self.find(session, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      
      case args.first
      when :all then find_every(session, options)
      end
    end
    
    def self.find_every(session, options)
      response = session.query :queryResponse=>query_string(options)
      
      collection = Salesforce::Collection.new 
      collection.total_results = response.queryResponse.result[:size].to_i
      
      if collection.total_results == 1
        collection << initialize_from_hash(response.queryResponse.result.records)
      else
        response.queryResponse.result.records.each { |r| collection << initialize_from_hash(r) }
      end
      
      collection
    end
    
    def self.query_string(options={})
      columns = (options[:select] || [:id]).join ', '
      "select #{columns} from #{table_name}"
    end
    
    def self.initialize_from_hash(hash)
      if hash[:type] == 'Account'
        object = Salesforce::Account.new
      end
      hash.each do |pair|
        unless pair[0] == :type || pair[0] == :Id
          object.__send__ "#{pair[0].to_s.downcase}=", pair[1]
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