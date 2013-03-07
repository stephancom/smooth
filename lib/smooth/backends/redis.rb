module Smooth
  module Backends
    class Redis < Base
      attr_reader :connection,
                  :namespace

      def initialize options={}
        @namespace        = options[:namespace]
        @priority         = options[:priority] || 0
        @connection       = ::Redis.new()
      end

      def create attributes={}
        attributes.symbolize_keys!
        attributes[:created_at] = attributes[:updated_at] = touch
        attributes[:id] = increment_id
        connection.hset("#{ namespace }:records", attributes[:id], JSON.generate(attributes))
        attributes
      end

      def update attributes={}
        attributes.symbolize_keys!
        if record = show(attributes[:id])
          record.merge!(attributes)
          record[:updated_at] = touch
          connection.hset("#{ namespace }:records", attributes[:id], JSON.generate(record))
          record
        end
      end

      def destroy id
        !!(connection.hdel("#{ namespace }:records", id.to_s))
      end

      def index
        records = connection.hvals("#{ namespace }:records")
      end 

      def show id
        record = connection.hget("#{ namespace }:records", id)
        parsed = JSON.parse(record)
        parsed && parsed.symbolize_keys!
        parsed
      end

      protected
        def maximum_updated_at
          connect.get("#{ namespace }:maximum_updated_at")
        end

        def touch
          stamp = Time.now.to_i
          connection.set("#{ namespace }:maximum_updated_at", stamp)
          stamp
        end

        def increment_id
          connection.incr("#{ namespace }:id_incrementer")
        end
    end
  end
end