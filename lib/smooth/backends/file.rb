module Smooth
  module Backends
    class File < Base

      class << self
        attr_accessor :data_directory, :flush_threshold
      end

      self.data_directory = Smooth.data_directory
      self.flush_threshold = 300

      FileUtils.mkdir_p(data_directory)

      attr_accessor :storage,
                    :namespace

      def initialize options={}
        super

        @data_directory       = options[:data_directory]
        restore if ::File.exists?(storage_path)

        setup_periodic_flushing
      end


      def storage_path
        ::File.join(data_directory, "#{ namespace }.json")
      end

      def url
        "file://#{ storage_path }"
      end


      def kill
        @periodic_flusher && @periodic_flusher.kill
      end

      def setup_periodic_flushing
        @periodic_flusher ||= Thread.new do
          while true
            flush
            sleep 20
          end
        end
      end

      protected

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
