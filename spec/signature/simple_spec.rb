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

    it "sets the default field names" do
      @signature.key_field.should == :id
    end

    it "allows changing the header names" do
      @signature.key_header = 'Api-Id'
      @signature.key_header.should == 'Api-Id'

      @signature.timestamp_header = 'Api-Timestamp'
      @signature.timestamp_header.should == 'Api-Timestamp'

      @signature.signature_header = 'Api-Sig'
      @signature.signature_header.should == 'Api-Sig'
    end

    it "allows setting header values before header names" do
      @signature.key = '12345'
      @signature.key_header = 'X-Test-Api-Key'
      @signature.key.should == '12345'
    end

    it "allows changing the field names" do
      @signature.key_field = :_id
      @signature.key_field.should == :_id
    end

    it "allows changing the header names via options" do
      s = Signature::Simple.new(RequestProxy.proxy(@request), {:signature_header => 'Foo-Bar'})
      s.signature_header.should == 'Foo-Bar'
    end

    it "allows setting header names and values via options" do
      s = Signature::Simple.new(RequestProxy.proxy(@request), {
        :key => 'mykey',
        :key_header => 'X-My-Key',
      })
      s.key.should == 'mykey'
      s.key_header.should == 'X-My-Key'
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

    it "invalidates an existing signature" do
      @signature.should be_valid_signature
      @signature.request_signature = nil
      @signature.should_not be_valid_signature
    end

    it "does not validate when secret is blank" do
      @request.options[:headers]['X-Api-Signature'] = 'a4c925a22e265eaa418d409f84be3c6a'
      @signature.secret = nil
      @signature.should_not be_valid_signature
    end

    it "does not validate when key is blank" do
      @request.options[:headers]['X-Api-Signature'] = '7cda71f498f19c96f24a2381d5123a1d'
      @signature.key = nil
      @signature.should_not be_valid_signature
    end

    it "sets the key" do
      @signature.key = 'foobar'
      @signature.key.should == 'foobar'
    end

    it "sets the timestamp" do
      t = Time.now.to_i + 23
      @signature.timestamp = t
      @signature.timestamp.to_s.should == t.to_s
    end

    it "sets the request signature" do
      @signature.request_signature = 'foobar'
      @signature.request_signature.should == 'foobar'
    end

    it "sets the correct id_hash parameters" do
      @signature.id_hash.should == {:id => '1234567890'}
      @signature.key_field = :_id
      @signature.id_hash.should == {:_id => '1234567890'}
    end

    it "has valid format with correct parameters" do
      @signature.should be_valid_format
    end

    it "does not have valid format with incorrect parameters" do
      request = Mock::Request.new({:method => 'GET', :host => 'api.example.com', :path => '/foo/bar/1.json'})
      signature = Signature.build(:simple, request, :secret => 'MySecret')
      signature.should_not be_valid_format
    end

    it "sets the request headers when signing" do
      @signature.secret = 'new-secret'
      @signature.sign!
      @request.headers['X-Api-Signature'].should == @signature.request_signature
    end
  end
end
