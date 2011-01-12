module JohnHancock::RequestProxy

  class RackRequest < JohnHancock::RequestProxy::Base
    proxies Rack::Request
  end

end
