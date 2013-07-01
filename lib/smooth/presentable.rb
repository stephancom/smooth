module Smooth
  class DefaultPresenter
    def default
      [:id]
    end
  end

  module Presentable
    extend ActiveSupport::Concern

    included do
      unless ancestors.include?(Smooth::Queryable)
        send(:include,Smooth::Queryable)
      end

      column_names = self.column_names.map {|c| ":#{ c }" }.join(", ") rescue []
      code = "class ::#{ to_s }DefaultPresenter; def self.default; [#{ column_names }];end;end"
      eval(code)

      extend(Smooth::MetaData::Adapter)
      register_resource_meta_data(self)
    end

    def presenter
      self.class.presenter_class
    end

    def presenter_format format
      if presenter.respond_to?(format)
        presenter.send(format)
      elsif self.class.default_presenter_class.respond_to?(format)
        self.class.default_presenter_class.send(format)
      else
        []
      end
    end

    def resource_columns
      []
    end

    def present_as(format=:default)
      record = self
      format = :default unless presenter.respond_to?(format)

      presenter_format(format).inject({}) do |memo,item|
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
        begin
          "#{ to_s }Presenter".constantize
        rescue
          default_presenter_class
        end
      end

      def default_presenter_class
        "#{ to_s }DefaultPresenter".constantize rescue Smooth::DefaultPresenter
      end

      def present params={}
        scope = query(params)
        Smooth::Presentable::Chain.new(scope)
      end
    end
  end
end
