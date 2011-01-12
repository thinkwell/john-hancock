module JohnHancock::Signature

  class MockSignature < JohnHancock::Signature::Base

    def initialize(request=nil, options = {})
      request ||= JohnHancock::Mock::Request.new(options.delete(:request_options) || {})
      proxy = JohnHancock::RequestProxy::MockRequest.new(request, options.delete(:proxy_options) || {})
      super(proxy, options)
    end


    def signature
      options[:signature] || signature_base_string
    end

    def signature_base_string
      options[:signature_base_string]
    end
  end

end
