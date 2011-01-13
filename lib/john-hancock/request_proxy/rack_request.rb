module JohnHancock::RequestProxy

  class RackRequest < JohnHancock::RequestProxy::Base
    proxies ::Rack::Request

    def method;              request.request_method;    end
    def query_parameters;    request.GET;               end
    def post_parameters;     request.POST;              end

    def headers
      @headers ||= defined?(ActionDispatch::Http::Headers) ?
        ActionDispatch::Http::Headers.new(request.env) :
        Headers.new(request.env)
    end
  end

end
