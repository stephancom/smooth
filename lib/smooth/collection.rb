module Smooth
  class Collection
    include ActiveModel::ArraySerializerSupport

    class_attribute :model_class

    def self.model_class
      @model_class ||= self.name.gsub('::Collection','').constantize
    end

    attr_accessor :options

    def initialize model_class=nil, *args
      @options = args.extract_options! || {}
    end

  end
end
