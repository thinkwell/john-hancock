require 'spec_helper'

module JohnHancock
  describe RequestProxy do

    describe 'self.proxy' do
      it "returns a proxy class for a request" do
        RequestProxy.proxy(Mock::Request.new({})).should be_a(RequestProxy::MockRequest)
      end

      it "returns a proxy class for a subclass of a known request" do
        RequestProxy.proxy(Mock::ChildRequest.new({})).should be_a(RequestProxy::MockRequest)
      end

      it "raises an error for an unknown request type" do
        expect { RequestProxy.proxy('foobar') }.to raise_error(RequestProxy::UnknownRequestType)
      end
    end

  end
end
