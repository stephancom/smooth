module Smooth
  module Backends
    class File

      class << self
        attr_accessor :data_directory, :flush_threshold
      end

      self.data_directory = Smooth::DataDirectory
      self.flush_threshold = 300

      FileUtils.mkdir_p(data_directory)

      attr_accessor :storage,
                    :namespace

      def initialize options={}
        @id_counter           = 0
        @maximum_updated_at   = Time.now.to_i
        @storage              = {id_counter: @id_counter, records: {}, maximum_updated_at: @maximum_updated_at}
        @data_directory       = options[:data_directory]
        @namespace            = options[:namespace]

        restore if ::File.exists?(storage_path)
      end

      def records
        @storage[:records]
      end

      def maximum_updated_at 
        @storage[:maximum_updated_at]
      end

      def storage_path
        ::File.join(data_directory, "#{ namespace }.json")
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

      def kill
        @periodic_flusher && @periodic_flusher.kill
      end

      def setup_periodic_flushing
        @periodic_flusher = Thread.new do
          while true
            flush 
            sleep 20
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

        def throttled?
          @last_flushed_at && (Time.now.to_i - @last_flushed_at) < self.class.flush_threshold
        end

        def restore
          from_disk = JSON.parse( IO.read(storage_path) ) rescue {}

          unless from_disk[:maximum_updated_at] && from_disk[:id_counter] && from_disk[:records]
            return
          end

          @storage = from_disk && true
        end

        def flush force=false
          return if !force && throttled?

          ::File.open(storage_path,'w+') do |fh|
            fh.puts( JSON.generate(storage) )            
            @last_flushed_at = Time.now.to_i
          end
        end

        def data_directory
          @data_directory || self.class.data_directory          
        end

    end
  end
end  
