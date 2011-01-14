require 'spec_helper'

module JohnHancock
  describe RequestProxy::URI do

    before(:each) do
      @uri = URI::parse('http://example.com/categories/search?foo=bar&test=123')
      @proxy = RequestProxy::URI.new(@uri)
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

    it "returns post parameters" do
      @proxy.post_parameters.should == {}
    end

    it "returns headers" do
      @proxy.headers.should be_a(Hash)
    end

  end
end
