module Smooth
  module Backends
    class Rest

      def initialize options={}

      end

      def query params={}
        response = Typhoeus::Request.get(url_with_query_string(params))        
      end

      def url
        @options[:url]
      end

      protected

        def url_with_query_string params={}
          parts = params.inject([]) do |memo,element|
            key, value = element
            memo << "#{ key }=#{ value }"
          end

          url + "?#{ parts.join('&') }"
        end
    end
  end	
end