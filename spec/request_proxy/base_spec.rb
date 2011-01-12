require 'spec_helper'

module JohnHancock
  describe RequestProxy::Base do

    describe "self.proxies" do
      it "adds new proxy classes" do
        JohnHancock::RequestProxy.available_proxies[Mock::Request].should == RequestProxy::MockRequest
      end
    end

    describe "parameters" do
      before(:each) do
        @request = Mock::Request.new({
          :get => {'foo' => 'bar', 'c' => 'd'},
          :post  => {'a' => 'b', 'c' => 'd2'},
          :headers => {'Authorization' => 'foo=bar'},
        })
        @proxy = RequestProxy.proxy(@request)
      end

      it "returns the union of query and post parameters" do
        @proxy.parameters.keys.sort.should == ['a', 'c', 'foo']
      end

      it "overrides get parameters with post parameters" do
        @proxy.parameters['c'].should == 'd2'
      end
    end


    describe "standard_port" do
      it "returns 80 for http" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http'})).standard_port.should == 80
      end

      it "returns 443 for https" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'https'})).standard_port.should == 443
      end
    end

    describe "standard_port?" do
      it "returns true for standard ports" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http',  :port =>  80})).should be_standard_port
        RequestProxy.proxy(Mock::Request.new({:scheme => 'https', :port => 443})).should be_standard_port
      end

      it "returns false for non-standard ports" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http',  :port => 8080})).should_not be_standard_port
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http',  :port =>  443})).should_not be_standard_port
        RequestProxy.proxy(Mock::Request.new({:scheme => 'https', :port =>   80})).should_not be_standard_port
        RequestProxy.proxy(Mock::Request.new({:scheme => 'https', :port => 8443})).should_not be_standard_port
      end
    end


    describe "port_string" do
      it "returns an empty string for the standard port" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http',  :port => 80})).port_string.should == ''
      end

      it "returns a string for a non-standard port" do
        RequestProxy.proxy(Mock::Request.new({:scheme => 'http',  :port => 8080})).port_string.should == ':8080'
      end
    end

  end
end
