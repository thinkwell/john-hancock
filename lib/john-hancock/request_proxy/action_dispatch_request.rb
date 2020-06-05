module JohnHancock::RequestProxy

  class ActionDispatchRequest < JohnHancock::RequestProxy::Base
    proxies ::ActionDispatch::Request

    def method;              request.request_method;    end
    def query_parameters;    request.GET;               end
    def post_parameters;     request.POST;              end

    def headers
      @headers ||= defined?(ActionDispatch::Http::Headers) ?
        ActionDispatch::Http::Headers.new(request) :
        Headers.new(request)
    end
  end

end
