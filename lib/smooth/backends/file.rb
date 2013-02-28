module Smooth
  module Backends
    class File
      class << self
        attr_accessor :data_directory
      end

      self.data_directory = Smooth::DataDirectory
      
      attr_accessor :storage,
                    :namespace

      def initialize options={}
        @storage = {}
        @id_counter = 0
      end

      def index
        @storage.values
      end

      def update attributes={}
        attributes.symbolize_keys!
        record = @storage[record[:id]]
        record.merge!(attributes)
        record
      end

      def create attributes={}
        attributes.symbolize_keys!
        attributes[:id] = increment_id
        @storage[attributes[:id]] ||= attributes
      end

      def show id
        @storage[id.to_i]
      end

      def destroy id 
        record = @storage.delete(id)
        !record.nil?
      end

      protected
        def increment_id
          @id_counter += 1
        end

        def storage=(object={})
          @storage = object
        end

        def storage_path
          File.join(self.class.data_directory, "#{ namespace }.json")
        end

        def flush
          File.open(storage_path,'w+') do |fh|
            fh.puts( JSON.generate(storage) )            
          end
        end
    end
  end
end  
