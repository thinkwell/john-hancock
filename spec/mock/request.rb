module JohnHancock
module Mock

  class Request

    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def method
      options[:method] || 'GET'
    end

    def scheme
      options[:scheme] || 'http'
    end

    def host
      options[:host] || 'example.com'
    end

    def port
      options[:port] || 80
    end

    def path
      options[:path] || ''
    end

    def GET
      options[:get] || {}
    end

    def POST
      options[:post] || {}
    end

    def headers
      options[:headers] || {}
    end

  end

  class ChildRequest < Request
  end

end
end
