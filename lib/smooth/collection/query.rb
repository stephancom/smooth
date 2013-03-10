module Smooth
  class Collection
    class Query < Hash

      def initialize options={}
        self.merge!(options)
      end

      def cache_key
        self.keys.sort.inject([]) {|memo, key| memo << "#{ key }:#{ self.send(:[], key) }" }.join("/")
      end
    end
  end
end