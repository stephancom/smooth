module Smooth
  class Collection
    include Cacheable

    InvalidBackend = Class.new(Exception)

    attr_reader :options, :backend

    # Create an instance of a Smooth::Collection.
    #
    # Examples:
    #
    #   Smooth::Collection.new(namespace: "namespace", backend: "file")
    #
    #
    def initialize namespace, options={}
      if namespace.is_a?(Hash)
        options = namespace
      end

      if namespace.is_a?(String)
        options[:namespace] = namespace
      end

      @options = options

      if options[:model] and !options[:backend]
        options[:backend] = "active_record"
      end

      options[:backend] ||= "file"

      if options[:backend].is_a?(String)
        @backend = "Smooth::Backends::#{ @options[:backend].camelize }".constantize.new(backend_options)
      end

      validate_backend

      if options[:cache].is_a?(String)
        options[:cache] = {
          backend: "redis"
        }
      end

      if options[:cache]
        @cache_adapter = create_cache_adapter(options[:cache])
      end

      @model_class = options[:model_class] || Smooth::Model

      @models = Array(options[:models])
    end

    def sync method="read", model={}, options={}, &block

      case method.to_sym

      when :read
        fetch_from_index
      when :update
        model = data_to_model(model,options)
        backend.update model.to_json
        fetch_from_index
      when :create
        model = data_to_model(model,options)
        backend.create model.to_json
        fetch_from_index
      when :destroy
        backend.destroy model.id
      else
        fetch_from_index
      end
    end

    def add data={}, options={}
      options[:collection] = self

      model = data_to_model(data, options)

      @models << model

      model
    end

    def models
      Array(@models)
    end

    def url
      backend.url rescue @namespace
    end

    def query params={}, options={}
      query = Query.new(params)
      query = apply_scope_parameters_to(query)

      return backend.query(query) unless cacheable?

      cache_adapter.fetch(query.cache_key) do
        backend.query(query)
      end
    end

    def fetch options={}
      response = query(options, options[:query_options])
      reset parse(response, options)
    end

    def parse response, options={}
      response
    end

    def reset models=nil
      @models = Array(models)
    end

    def length
      models.length
    end

    private
      def fetch_from_index
        @models = Array(backend && backend.index)
      end

      def data_to_model data={}, options={}
        if data.class.ancestors.include?(Smooth::Model)
          model = data
        elsif data.is_a?(Hash)
          model = model_class.new(data, options)
        end

        model.collection ||= self
      end

      def model_class
        @model_class || Smooth::Model
      end
      def cache_adapter
        @cache_adapter
      end

      def cacheable?
        !!(options[:cache])
      end

      def apply_scope_parameters_to query={}
        query
      end

      def namespace
        namespace = options[:namespace]

        if options[:backend] == "active_record" and options[:model] and namespace.nil?
          namespace = options[:model].table_name
        end

        namespace
      end

      def backend_options
        return options[:backend_options] if options[:backend_options]

        default = {namespace: namespace}
        default[:model] ||= options[:model]

        default
      end

      def validate_backend
        raise InvalidBackend unless backend.respond_to?(:query)
      end
  end
end