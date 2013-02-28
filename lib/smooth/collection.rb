module Smooth
  class Collection

    InvalidBackend = Class.new(Exception)

    attr_reader :backend

    def initialize options={}
      @namespace  = options[:namespace] 

      raise "Collections require a namespace" if @namespace.nil?

      @backend    = options[:backend] || "file"
      validate_backend
    end

    def namespace
      @namespace
    end

    def sync method, hash={}, options={}
      if method == "read" and !hash[:id].nil?
        return backend.index()
      end

      if method == "read" and !hash[:id].nil?
        return backend.show( hash[:id] )
      end

      if method == "create"
        return backend.create( hash )
      end

      if method == "update"
        return backend.update( hash )
      end

      if method == "delete"
        return backend.destroy( hash )
      end
    end    

    protected
      def validate_backend
        begin
          if @backend.is_a?(String)
            @backend = eval("Smooth::Backends::#{ @backend.capitalize }").new(namespace: namespace)
          end

          %w{index create update show destroy}.each do |action|
            raise InvalidBackend unless backend.respond_to?(action)
          end        

        rescue         
          raise InvalidBackend
        end        
      end    
  end
end