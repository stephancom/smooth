module Smooth
  module Resource
    extend ActiveSupport::Concern

    included do
      include Smooth::Queryable
      include Smooth::Presentable
    end
  end
end
