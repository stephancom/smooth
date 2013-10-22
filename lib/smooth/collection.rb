module Smooth
  class Collection
    include Cacheable

    InvalidBackend = Class.new(Exception)

    attr_reader :options, :backend

    class << self
      attr_accessor :model_class,
                    :backend,
                    :namespace
    end

    def self.uses_model model=Smooth::Model
      self.model_class = model
      self
    end

    def self.uses_namespace namespace="smooth:collections"
      self.namespace = namespace
      self
    end

    def self.uses_backend backend=:file
      self.backend = backend
      self
    end

    # Create an instance of a Smooth::Collection.
    #
    # Examples:
    #
    #   Smooth::Collection.new(namespace: "namespace", backend: "file")
    #
    def initialize namespace, models=[], options={}
      if models.is_a?(Hash)
        options = models
        models  = Array(options[:models])
      end

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

      validate_backend

      if options[:cache].is_a?(String)
        options[:cache] = {
          backend: "redis"
        }
      end

      if options[:cache]
        @cache_adapter = create_cache_adapter(options[:cache])
      end

      @model_class = options[:model_class] || self.class.model_class

      @models = models
    end

    def sync method="read", model={}, options={}, &block

      case method.to_sym

      when :read
        fetch_from_index
      when :update
        model = data_to_model(model,options)
        backend.update model.as_json
        fetch_from_index
      when :create
        model = data_to_model(model,options)
        attributes = backend.create(model.as_json)
        fetch_from_index

        model = data_to_model(attributes, options)
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

    def find_by attribute, value
      q = {}
      q[attribute.to_sym] = value
      data_to_model query(q).first
    end

    def find id
      find_by(:id, id)
    end

    def models
      fetch_from_index unless @fetched

      Array(@models).map do |model|
        data_to_model(model, collection: self)
      end
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
        @fetched = true
        @models = Array(backend && backend.index)
      end

      def data_to_model data={}, options={}
        data = JSON.parse(data) if data.is_a?(String)

        begin
          if data.class.ancestors.include?(Smooth::Model)
            model = data
          elsif data.is_a?(Hash)
            model = model_class.new(data, options)
          end

          model.collection ||= self

          model
        rescue
          binding.pry if $k
        end
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
        namespace = options[:namespace] || self.class.namespace

        if options[:backend] == "active_record" and options[:model] and namespace.nil?
          namespace = options[:model].table_name
        end

        namespace
      end

      def backend_options
        default = {namespace: namespace}
        default[:model] ||= options[:model]

        default.merge!(backend_options: options.fetch(:backend_options,{}))
        default
      end

      def configure_backend
        options[:backend] ||= self.class.backend || "file"
        options[:backend] = options[:backend].to_s if options[:backend].is_a?(Symbol)

        if options[:backend].is_a?(String)
          klass = if options[:backend].match(/::/)
            options[:backend]
          else
            "Smooth::Backends::#{ options[:backend].camelize }"
          end

          @backend = klass.constantize.new(backend_options)
        end
      end

      def validate_backend
        configure_backend unless @backend

        raise InvalidBackend unless backend.respond_to?(:query)
        @backend
      end
  end
end
