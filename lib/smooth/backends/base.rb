module Smooth
  module Backends
    class Base

      def initialize options={}
        @id_counter           = 0
        @maximum_updated_at   = Time.now.to_i
        @namespace            = options[:namespace]

        records               = options[:records] || {}

        if records.is_a?(Array)
          records = records.select {|r| r.is_a?(Hash) }.inject({}) do |memo,record|
            record.symbolize_keys!
            record[:id] ||= @id_counter += 1
            memo[ record[:id] ] = record
            memo
          end
        end

        @storage              = {id_counter: @id_counter, records: records, maximum_updated_at: @maximum_updated_at}
      end

      def records
        @storage[:records]
      end

      def maximum_updated_at 
        @storage[:maximum_updated_at]
      end

      def index
        records.values
      end

      def show id
        records[id.to_i]
      end

      def update attributes={}
        attributes.symbolize_keys!
        @storage[:maximum_updated_at] = attributes[:updated_at] = Time.now.to_i
        record = records[attributes[:id]]
        record.merge!(attributes)
        record
      end

      def create attributes={}
        attributes.symbolize_keys!
        attributes[:id] = increment_id
        @storage[:maximum_updated_at] = attributes[:created_at] = attributes[:updated_at] = Time.now.to_i
        records[attributes[:id]] ||= attributes
      end

      def destroy id 
        record = records.delete(id)
        !record.nil?
      end
      
      # A Naive query method which only matches for equality
      def query params={}
        params.symbolize_keys!

        Array(index).select do |record|
          params.keys.all? do |key|
            record[key] == params[key]
          end
        end
      end            
      
      protected      

        def increment_id
          @id_counter += 1
        end

        def storage=(object={})
          @storage = object
        end
    end
  end
end      