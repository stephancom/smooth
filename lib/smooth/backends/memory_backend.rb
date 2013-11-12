class Smooth::MemoryBackend < Smooth::Backend
  attr_accessor :records, :options

  def initialize options={}
    @options      = options.dup
    @id_sequence  = @options.fetch(:id_sequence, 0)
    records       = @options.fetch(:records, [])

    @records = records.inject({}) do |memo,object|
      object.symbolize_keys!
      id = assign_id_to(object)
      memo[id] = object
      memo
    end
  end

  def all
    Array(records.values)
  end

  def create attributes={}, options={}
    id      = assign_id_to(attributes)
    exists  = self.records.fetch(id, nil)

    if exists && !options[:force]
      raise Smooth::InvalidRecord, "Invalid Record. Duplicate id present on create"
    end

    self.records[id] = attributes
  end

  def destroy id
    result = self.records.delete(id)
    raise NotFound unless result

    result
  end

  def show id
    self.records.fetch(id, nil)
  end

  def update id, attributes={}
    existing = show(id)

    raise NotFound unless existing

    existing.merge! timestamp_update_of(object)

    self.records[id] = existing

    existing
  end

end
