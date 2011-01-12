module JohnHancock::RequestProxy

  class MockRequest < JohnHancock::RequestProxy::Base
    proxies JohnHancock::Mock::Request
  end

end
