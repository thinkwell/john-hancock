require 'spec_helper'

module JohnHancock
  describe RequestProxy::NetHTTPRequest do
    before(:each) do
      @request = Net::HTTP::Get.new('/categories/search?foo=bar&test=123')
      @proxy = RequestProxy::NetHTTPRequest.new(@request)
    end

    it "returns the method" do
      @proxy.method.should == 'GET'
    end

    it "returns the path" do
      @proxy.path.should == '/categories/search'
    end

    it "returns query parameters" do
      @proxy.query_parameters.should be_a(Hash)
      @proxy.query_parameters.sort.should == [['foo', 'bar'], ['test', '123']]
    end

    it "returns post parameters" do
      @proxy.post_parameters.should == {}
    end

    it "returns headers" do
      @proxy.headers.should respond_to('[]')
    end

    it "allows setting headers" do
      @proxy.set_header('foo', 'bar')
      @proxy.headers['foo'].should == 'bar'
    end
  end
end
