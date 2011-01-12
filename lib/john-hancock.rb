require 'active_support/inflector'
require 'john-hancock/signature'
require 'john-hancock/request_proxy'

module JohnHancock
  Signature.autoload :Base,      'john-hancock/signature/base'
  Signature.autoload :Simple,    'john-hancock/signature/simple'
  Signature.autoload :Advanced,  'john-hancock/signature/advanced'
  Signature.autoload :OAuth,     'john-hancock/signature/oauth'
  Signature.autoload :EC2,       'john-hancock/signature/ec2'

  RequestProxy.autoload :Base,   'john-hancock/request_proxy/base'
end
