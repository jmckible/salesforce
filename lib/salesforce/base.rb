module Salesforce
  class Base
    
    attr_accessor :id
    
    def initialize(params={})
      params.each do |key, value|
        __send__ "#{key}=", value if respond_to? "#{key}="
      end
    end
    
    class << self
      def table_name
        name.split('::').last
      end
      
      def columns
        {:Id=>:id}
      end
      
      def belongs_to
        {}
      end
      
      def find(session, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        
        case args.first
          when :first   then find_initial session, options
          when :last    then find_last    session, options
          when :all     then find_every   session, options
          when :locator then find_locator session, options
          else               find_from_id session, args.first
        end
      end
      
      def find_from_id(session, id)
        find_every(session, :conditions=>"Id = '#{id}'").first
      end
      
      def find_initial(session, options)
        find_every(session, options).first
      end
      
      def find_last(session, options)
        find_every(session, options).last
      end
    
      def find_by_soql(session, query)
        response = session.query :queryResponse=>query
        raise Salesforce::InvalidParameters unless response[:Fault].nil?
        process_response response.queryResponse
      end
    
      def find_every(session, options)
        response = session.query :queryResponse=>query_string(options)
        raise Salesforce::InvalidParameters unless response[:Fault].nil?
        process_response response.queryResponse
      end
      
      def find_locator(session, options)
        response = session.queryMore :queryLocator=>options[:id]
        raise Salesforce::InvalidParameters unless response[:Fault].nil?
        process_response response.queryMoreResponse
      end
      
      def like(session, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        query   = args.first
        
        on = options[:on] || :name
        column = columns.invert[on]
        options.delete :on
        
        options[:order] ||= on unless column.nil?
        
        if column.nil? || query.nil? || query == '' 
        else
          options[:conditions] = [options[:conditions]] unless options[:conditions].is_a? Array
          string = options[:conditions].shift
          if string.is_a? String
            string = string + " AND #{column} LIKE ?"
          else
            string = "#{column} LIKE ?"
          end
          
          values = options[:conditions].dup
          
          options[:conditions] = [string]
          values.each{|v| options[:conditions] << v}
          options[:conditions] << "%#{query}%"
        end
        
        find session, :all, options
      end
      
      def process_response(query_response)
        collection = Salesforce::Collection.new 
      
        collection.total_results = query_response.result[:size].to_i
        collection.done = false if query_response.result.done == 'false'
        collection.locator = query_response.result[:queryLocator] if query_response.result[:queryLocator]
      
        return collection if collection.total_results == 0
      
        records = query_response.result.records
        records = [records] unless records.is_a?(Array)
        records.each do |record| 
          object = initialize_from_hash record
          collection << object if object
        end
  
        collection
      end
    
      def query_string(options={})
        cols = options[:select] || columns.values
        cols = [cols] unless cols.is_a? Array
        cols = cols.map{ |c| columns.invert[c] }.compact.map{|c|c.to_s}.join ', '
        
        unless belongs_to.empty?
          belongs_to.each do |klass, attribute|
            cols = cols + ', ' + klass.columns.keys.collect{|c| "#{klass.table_name}.#{c}"}.join(', ')
          end
        end
        
        base = "SELECT #{cols} FROM #{table_name}"
        
        conditions = options[:conditions]
        if conditions
          if conditions.is_a? Array
            string = conditions.shift
            string.gsub! '?' do
              value = conditions.shift
              unless value.is_a? Integer
                value.gsub! "'", "\'"
                value = "'#{value}'"
              end
              value
            end
            conditions = string
          end
          base += " WHERE #{conditions}"
        end
        
        order = options[:order]
        if order
          if order.is_a? String
            base += " ORDER BY #{order}"
          else
            attribute = columns.invert[order]
            if attribute
              base += " ORDER BY #{attribute.to_s}"
            end
          end
        end
        
        base
      end
    
      def initialize_from_hash(hash)
        object = Salesforce.const_get(hash[:type]).new

        hash.each do |key, value|
          unless key == :type || key == :Id
            if value.is_a? Hash
              result = initialize_from_hash value
              method = "#{object.class.belongs_to[result.class]}="
            else
              method = object.class.columns[key].to_s + '='
              result = value
            end
            object.__send__(method, result) if object.respond_to? method
          end
        end
        object.id = hash[:Id].first
        object
        
      rescue NameError # Class not yet implemented
        return nil
      end
    
    end
  
    
  end
end