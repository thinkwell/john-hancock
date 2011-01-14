require 'cgi'

module JohnHancock::RequestProxy

  class URI < JohnHancock::RequestProxy::Base
    proxies ::URI::Generic

    def method;              options[:method] || 'GET';                   end
    def post_parameters;     {};                                          end
    def headers;             {};                                          end

    def query_parameters
      return @query_parameters if @query_parameters

      @query_parameters = CGI.parse(request.query)

      # CGI.parse makes all values arrays
      # Don't use an array for a value with only one element
      @query_parameters.each do |key, val|
        @query_parameters[key] = val[0] if val.is_a?(Array) && val.size == 1
      end
    end
  end

end
