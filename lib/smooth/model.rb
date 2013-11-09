module Smooth
  class VirtusModel
    include Virtus
  end

  class Model < VirtusModel
    cattr_accessor :decorators

    self.decorators ||= Set.new

    def self.decorate_with *list
      list.each do |decorator|
        self.send(:include, decorator)

        if decorator.respond_to?(:decorate)
          self.decorators << decorator
        end
      end
    end

    def self.inherited descendant
      super
      decorators.each do |decorator|
        decorator.decorate(descendant)
      end
    end
  end
end
