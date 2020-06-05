require 'active_support/inflector'
require 'john-hancock/signature'
require 'john-hancock/request_proxy'

module JohnHancock
  Signature.autoload :Base,      'john-hancock/signature/base'
  Signature.autoload :Simple,    'john-hancock/signature/simple'
  Signature.autoload :Advanced,  'john-hancock/signature/advanced'
  Signature.autoload :OAuth,     'john-hancock/signature/oauth'
  Signature.autoload :EC2,       'john-hancock/signature/ec2'

  RequestProxy.autoload :Base,           'john-hancock/request_proxy/base'
  RequestProxy.autoload :Headers,        'john-hancock/request_proxy/headers'
  RequestProxy.autoload :NetHTTPRequest, 'john-hancock/request_proxy/net_httprequest'
  RequestProxy.autoload :RackRequest,    'john-hancock/request_proxy/rack_request'
  RequestProxy.autoload :TestRequest,    'john-hancock/request_proxy/test_request'
  RequestProxy.autoload :ActionDispatchRequest,    'john-hancock/request_proxy/action_dispatch_request'
  RequestProxy.autoload :URI,            'john-hancock/request_proxy/uri'
end
