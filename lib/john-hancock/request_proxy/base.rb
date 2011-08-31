module JohnHancock::RequestProxy
  class Base
    def self.proxies(klass)
      JohnHancock::RequestProxy.available_proxies[klass] = self
    end

    attr_accessor :request, :options


    ##############################################
    #
    # Subclasses should override:
    #

    # The HTTP method used (e.g. GET, POST)
    def method
      request.method
    end


    # The protocol used (e.g. http or https)
    def scheme
      request.scheme
    end


    # The host (e.g. example.com)
    def host
      request.host
    end


    # The port (e.g. 80)
    def port
      request.port
    end


    # The path (e.g. /foo/bar/file.html)
    def path
      request.path
    end


    # A hash of GET parameters
    def query_parameters
      request.GET
    end


    # A hash of POST parameters
    def post_parameters
      request.POST
    end


    # Returns an object with a +[]+ method for fetching headers
    def headers
      request.headers
    end


    def set_header(key, val)
      headers[key] = val.to_s
    end

    #
    ##############################################



    def initialize(request, options = {})
      @request = request
      @options = options
    end


    def parameters
      query_parameters.merge(post_parameters)
    end

    def standard_port
      case scheme
        when 'https' then 443
        else 80
      end
    end

    def standard_port?
      port == standard_port
    end

    def port_string
      port == standard_port ? '' : ":#{port}"
    end
  end
end
