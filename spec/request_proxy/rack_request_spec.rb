require 'spec_helper'
require 'rack/request'
require 'rack/mock'

module JohnHancock
  describe RequestProxy::RackRequest do

    context "for get requests" do
      before(:each) do
        @request = Rack::Request.new(Rack::MockRequest.env_for(
          'http://example.com/categories/search?foo=bar&test=123',
          {'HTTP_X_MY_HEADER' => 'foobar'}
        ))
        @proxy = RequestProxy::RackRequest.new(@request)
      end

      it "returns the method" do
        @proxy.method.should == 'GET'
      end

      it "returns the scheme" do
        @proxy.scheme.should == 'http'
      end

      it "returns the host" do
        @proxy.host.should == 'example.com'
      end

      it "returns the port" do
        @proxy.port.should == 80
      end

      it "returns the path" do
        @proxy.path.should == '/categories/search'
      end

      it "returns query parameters" do
        @proxy.query_parameters.should be_a(Hash)
        @proxy.query_parameters.sort.should == [['foo', 'bar'], ['test', '123']]
      end

      it "returns headers" do
        @proxy.headers['X-My-Header'].should == 'foobar'
      end
    end


    context "for post requests" do
      before(:each) do
        @request = Rack::Request.new(Rack::MockRequest.env_for(
          'http://example.com/categories/search?foo=bar&test=123',
          {:method => 'post', :params => {'foo' => 'foobar', 'x' => 'y'}}
        ))
        @proxy = RequestProxy::RackRequest.new(@request)
      end

      it "returns query parameters" do
        @proxy.query_parameters.should be_a(Hash)
        @proxy.query_parameters.sort.should == [['foo', 'bar'], ['test', '123']]
      end

      it "returns post parameters" do
        @proxy.post_parameters.should be_a(Hash)
        @proxy.post_parameters.sort.should == [['foo', 'foobar'], ['x', 'y']]
      end
    end

  end
end
