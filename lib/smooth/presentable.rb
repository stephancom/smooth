module Smooth

  class DefaultPresenter
    def default
      [:id]
    end
  end

  module Presentable
    extend ActiveSupport::Concern

    included do
      Smooth::MetaData.register_resource(self)
    end

    def present_as(format=:default)
      record  = self
      keys    = self.class.presenter_class && self.class.presenter_class.respond_to?(format) && self.class.presenter_class.send(format)
      keys    ||= self.class.default_presenter_attributes

      Array(keys).inject({}) do |memo,item|
        AttributeDelegator.pluck(record, item, memo)
      end
    end

    class AttributeDelegator
      def self.pluck(record, attribute, memo)
        if attribute.is_a?(Symbol) || attribute.is_a?(String)
          memo[attribute] = record.send(attribute)
          return memo
        end

        if attribute.is_a?(Hash)
          key         = attribute[:attribute] || attribute[:key]
          meth        = attribute[:method] || key
          presenter   = attribute[:presenter] || :default

          value       = record.send(meth)

          memo[key] = value.send(:present_as, presenter)
        end

        return memo
      end
    end

    module ClassMethods
      def presenter_class
        "#{ to_s }Presenter".constantize rescue nil
      end

      def default_presenter_attributes
        if respond_to?(:column_names)
          column_names.map(&:to_sym)
        end
      end

      def present params={}
        scope = scoped
        scope = query(params) if ancestors.include?(Smooth::Queryable)

        Smooth::Presentable::Chain.new(scope)
      end
    end
  end
end
