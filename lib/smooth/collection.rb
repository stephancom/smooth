module Smooth
  class Collection

    InvalidBackend = Class.new(Exception)

    attr_reader :namespace,
                :backend

    def initialize options={}
      @namespace = options[:namespace]
      
      options[:backend] ||= "file"

      begin
        backend_class = "Smooth::Backends::#{ options[:backend].capitalize }".constantize
        @backend = backend_class.new(namespace: namespace)

        %w{index create update show destroy}.each do |action|
          raise InvalidBackend unless backend.respond_to?()
        end        

      rescue         
        raise InvalidBackend
      end
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
  end
end