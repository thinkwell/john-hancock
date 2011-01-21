require 'spec_helper'

module JohnHancock
  describe Signature::Simple do

    before(:each) do
      @request = Mock::Request.new({
        :method => 'GET',
        :host => 'api.example.com',
        :headers => {
          'X-Api-Key' => '1234567890',
          'X-Api-Timestamp' => '1294870227',
          'X-Api-Signature' => '2ef24e5b8c1dedc23240fb564874c7a6'
        },
        :path => '/foo/bar/1.json',
        :get => {'param' => 'test'}
      })
      @signature = Signature.build(:simple, @request, :secret => 'MySecret')
    end


    it "doesn't modify options" do
        options = {:signature_header => 'foo-bar'}
        o = options.dup
        Signature.build(:simple, @request, options)
        options.should == o
    end

    it "sets the default header names" do
      @signature.key_header.should == 'X-Api-Key'
      @signature.timestamp_header.should == 'X-Api-Timestamp'
      @signature.signature_header.should == 'X-Api-Signature'
    end


    it "allows changing the header names" do
      @signature.key_header = 'Api-Id'
      @signature.key_header.should == 'Api-Id'

      @signature.timestamp_header = 'Api-Timestamp'
      @signature.timestamp_header.should == 'Api-Timestamp'

      @signature.signature_header = 'Api-Sig'
      @signature.signature_header.should == 'Api-Sig'
    end

    it "allows changing the header names via options" do
      s = Signature::Simple.new(RequestProxy.proxy(@request), {:signature_header => 'Foo-Bar'})
      s.signature_header.should == 'Foo-Bar'
    end

    it "fetches the api key" do
      @signature.key.should == '1234567890'
    end


    it "fetches the timestamp" do
      @signature.timestamp.to_i.should == 1294870227
    end

    it "fetches the existing signature" do
      @signature.request_signature.should == '2ef24e5b8c1dedc23240fb564874c7a6'
    end


    it "composes the signature base string" do
      @signature.signature_base_string.should == 'MySecret1234567890/foo/bar/1.json1294870227'
    end

    it "handles empty paths" do
      @request.options[:path] = ''
      @signature.signature_base_string.should == 'MySecret1234567890/1294870227'
    end

    it "generates the signature" do
      @signature.signature.should == '2ef24e5b8c1dedc23240fb564874c7a6'
    end

    it "generates the signature with no existing signature" do
      @request.options[:headers]['X-Api-Signature'] = nil
      @signature.signature.should == '2ef24e5b8c1dedc23240fb564874c7a6'
    end

    it "validates an existing correct signature" do
      @signature.should be_valid_signature
    end

    it "invalidates an existing incorrect signature" do
      @request.options[:headers]['X-Api-Signature'] = nil
      @signature.should_not be_valid_signature
    end

  end
end
