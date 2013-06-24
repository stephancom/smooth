module Smooth
  module Presentable
    extend ActiveSupport::Concern

    included do
      unless ancestors.include?(Smooth::Queryable)
        send(:include,Smooth::Queryable)
      end

      column_names = self.column_names.map {|c| ":#{ c }" }.join(", ")

      code = "class ::#{ to_s }Presenter; def self.default; [#{ column_names }];end;end"

      eval(code)
    end

    def presenter
      (self.class.to_s + "Presenter").constantize
    end

    def present_as(format=:default)
      record = self
      config = presenter.send(format)

      presented = config.inject({}) do |memo,item|
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
          key       = attribute[:attribute] || attribute[:key]
          meth      = attribute[:method] || key
          value     = record.send(meth)

          if attribute[:presenter]
            memo[key] = value.send(:present_as, attribute[:presenter])
          else
            memo[key] = value.respond_to?(:as_json) ? value.as_json : value
          end
        end

        return memo
      end
    end

    module ClassMethods
      def present params={}
        scope = query(params)
        Smooth::Presentable::Chain.new(scope)
      end
    end
  end
end
