module Salesforce
  class Base
    
    attr_accessor :id
    
    class << self
      def columns
        {:Id=>:id}
      end
      
      def find(session, args)
        if args.is_a?(String)
          find_one session, args
        else # Hash
          find_every session, args
        end
      end
    
      def find_one(session, id)
        find_every(session, :conditions=>"id = '#{id}'").first
      end
    
      def find_every(session, options)
        response = session.query :queryResponse=>query_string(options)
      
        raise Salesforce::InvalidParameters unless response[:Fault].nil?
      
        collection = Salesforce::Collection.new 
      
        collection.total_results = response.queryResponse.result[:size].to_i
        collection.done = false if response.queryResponse.result.done == 'false'
        collection.locator = response.queryResponse.result[:queryLocator] if response.queryResponse.result[:queryLocator]
      
        return collection if collection.total_results == 0
      
        records = response.queryResponse.result.records
        records = [records] unless records.is_a?(Array)
        records.each { |r| collection << initialize_from_hash(r) }
  
        collection
      end
    
      def query_string(options={})
        cols = options[:select] || columns.values
        cols = [cols] unless cols.is_a? Array
        cols = cols.map{ |c| columns.invert[c] }.compact.map{|c|c.to_s}.join ', '
        conditions = options[:conditions]
        base = "select #{cols} from #{table_name}"
        base += " where #{conditions}" if conditions
        base
      end
    
      def initialize_from_hash(hash)
        if hash[:type] == 'Account'
          object = Salesforce::Account.new
        elsif hash[:type] == 'Lead'
          object = Salesforce::Lead.new
        end
        hash.each do |pair|
          unless pair[0] == :type || pair[0] == :Id
            method = object.class.columns[pair[0]].to_s + '='
            object.__send__(method, pair[1]) if object.respond_to? method
          end
        end
        object.id = hash[:Id].first
        object
      end
    
      def table_name
        name.split('::').last
      end
    end
  end
end