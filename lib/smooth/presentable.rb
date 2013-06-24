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
        memo[item] = record.send(item)
        memo
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
