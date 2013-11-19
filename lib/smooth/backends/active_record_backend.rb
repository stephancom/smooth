class Smooth::ActiveRecordBackend < Smooth::Backend
  def initialize(options={})
    @prepared = @processed = true
    super
  end

  def all
    model_class.all
  end

  def create attributes={}
    model = model_class.create!(attributes)
    model
  end

  def show id
    model = model_class.find(id)
    model
  end

  def update id, attributes
    model_class.find(id)
    model && model.update_attributes(attributes)
    model
  end

  def destroy id
    model = model_class.find(id)
    model && model.destroy
    model
  end
end
