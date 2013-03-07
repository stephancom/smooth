module Smooth
  class Collection

    InvalidBackend = Class.new(Exception)

    attr_reader :options, :backend

    def initialize options={}
      @options = options.reverse_merge(:backend=>"file")

      if @options[:backend].is_a?(String)
        @backend = "Smooth::Backends::#{ @options[:backend].camelize }".constantize.new(backend_options)
      end

      validate_backend
    end

    def url
      backend.url rescue @namespace
    end

    def query params={}, options={}
      Query.run(self,apply_scope_parameters_to(params))
    end

    protected

      def apply_scope_parameters_to query_options={}
        query_options
      end

      def namespace
        options[:namespace]
      end

      def backend_options
        options[:backend_options] || {namespace: namespace}
      end

      def validate_backend
        raise InvalidBackend unless backend.respond_to?(:query)
      end    
  end
end