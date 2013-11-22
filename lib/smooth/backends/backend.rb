class Smooth::Backend
  attr_accessor :id_sequence,
                :last_modified,
                :backend_id,
                :model_class

  NotFound = Class.new(Exception)
  NotImplemented = Class.new(Exception)

  def initialize options
    @options        = options.dup

    @model_class    = @options.fetch :model_class, Smooth::Model
    @id_sequence    = @options.fetch :id_sequence, 0
    @records        = @options.delete(:records) || []

    prepare_records!
    process_records!
  end

  def all
    []
  end

  def id
    model_class.to_s.underscore.parameterize
  end

  def modified!
    self.last_modified = Time.now
    self
  end

  def touch
    modified!
  end

  def last_modified
    @last_modified || fetch_last_modified_date
  end

  protected

    def fetch_last_modified_date
      @last_modified ||= Time.now
    end

    def prepare_records!
      unless @prepared
        @records = @records.values if @records.is_a?(Hash)
        @records = Array(@records)
        @prepared = true
      end
    end

    def process_records!
      unless @processed
        @records = @records.inject({}) do |memo,object|
          object.symbolize_keys!
          id = assign_id_to(object)
          memo[id] = object
          memo
        end

        @processed = true
      end
    end

    def method_missing meth, *args, &blk
      if %w{create update show destroy}.include? meth.to_s
        raise NotImplemented, "Subclasses must implement their own #{meth} method"
      end

      if %w{each map select reject inject detect collect}.include? meth.to_s
        if all && all.respond_to?(meth)
          return all.send(meth,*args,&blk)
        end
      end

      super
    end

    def id_sequence
      @id_sequence ||= 0
    end

    def timestamp_update_of(object={})
      object[:updated_at] = touch.last_modified
      object
    end

    def timestamp_creation_of(object={})
      now = touch.last_modified

      object[:created_at] ||= now
      object[:updated_at] = now
      object
    end

    def assign_id_to(object)
      object[:id] ||= self.id_sequence += 1
      object[:id]
    end
end
