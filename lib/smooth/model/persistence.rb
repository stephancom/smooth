module Smooth::Model::Persistence
  extend ActiveSupport::Concern

  def destroy
    collection.destroy(self.id)
  end

  def update with_attributes
    collection.update(self.id, with_attributes)
  end

  def save options={}
    meth = persisted? ? :update : :create
    collection.sync(meth, self, options)
    true
  end

  def saved
    self if save
  end

  def persisted?
    (respond_to?(:id) && send(:id)).to_i > 0
  end

  module ClassMethods
    def update_all(with_attributes)
      collection.each do |model|
        model.update(with_attributes)
      end
    end

    def create attributes
      new(collection.create(attributes)).saved
    end

    def find id
      collection.find(id)
    end
  end
end
