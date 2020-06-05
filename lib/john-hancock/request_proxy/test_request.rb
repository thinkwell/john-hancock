module JohnHancock::RequestProxy

  class TestRequest < JohnHancock::RequestProxy::Base
    proxies ::ActionController::TestRequest

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
