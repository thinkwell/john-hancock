require 'net/http'

module JohnHancock::RequestProxy

  class NetHTTPRequest < JohnHancock::RequestProxy::Base
    proxies ::Net::HTTPRequest

    def method;          request.method;                              end
    def scheme;          raise NotImplementedError, "Not supported";  end
    def host;            raise NotImplementedError, "Not supported";  end
    def port;            raise NotImplementedError, "Not supported";  end
    def post_parameters; {};                                          end

    def path
      request.path.split('?', 2)[0]
    end

    def query_parameters
      return @query_parameters if @query_parameters
      return @query_parameters = {} unless request.path.include?('?')

      @query_parameters = CGI::parse(request.path.split('?', 2)[1])

      # CGI.parse makes all values arrays
      # Don't use an array for a value with only one element
      @query_parameters.each do |key, val|
        @query_parameters[key] = val[0] if val.is_a?(Array) && val.size == 1
      end
    end


    def headers
      request
    end

  end

end
