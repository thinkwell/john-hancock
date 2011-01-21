require 'spec_helper'

module JohnHancock
  describe Signature::Base do

    describe "initialize" do
      it "only accepts request proxies" do
        expect { Signature::Base.new(Mock::Request.new) }.to raise_error(TypeError)
      end

      it "doesn't modify options" do
        options = {:valid_timestamp_range => 300}
        o = options.dup
        Signature::Base.new(RequestProxy::MockRequest.new(Mock::Request.new), options)
        options.should == o
      end
    end


    describe "signature" do
      it "must be implemented by subclasses" do
        signature = Signature::Base.new(RequestProxy::MockRequest.new(Mock::Request.new))
        expect { signature.signature }.to raise_error(NotImplementedError)
      end
    end


    describe "signature_base_string" do
      it "must be implemented by subclasses" do
        signature = Signature::Base.new(RequestProxy::MockRequest.new(Mock::Request.new))
        expect { signature.signature_base_string }.to raise_error(NotImplementedError)
      end
    end


    describe "request_signature" do
      it "does not compute a new signature" do
        signature = Signature::MockSignature.new(nil, :request_options => {:get => {'signature' => 'Old Signature'}})
        signature.request_signature.should == 'Old Signature'
      end

      it "returns nil when no signature exists" do
        signature = Signature::MockSignature.new
        signature.request_signature.should == nil
      end
    end


    describe "valid_signature?" do
      it "returns true if computed signature matches request signature" do
        signature = Signature::MockSignature.new(nil,
          :signature => 'the man in the moon',
          :request_options => {:get => {'signature' => 'the man in the moon'}}
        )
        signature.should be_valid_signature
      end

      it "returns false if computed signature does not match request signature" do
        signature = Signature::MockSignature.new(nil,
          :signature => 'the man and the moon',
          :request_options => {:get => {'signature' => 'the man in the moon'}}
        )
        signature.should_not be_valid_signature
      end
    end

    describe "valid_timestamp?" do
      it "validates a correct timestamp" do
        signature = Signature::MockSignature.new(nil,
          :request_options => {:get => {'timestamp' => Time.now.to_i}}
        )
        signature.should be_valid_timestamp
      end

      it "invalidates a past timestamp" do
        signature = Signature::MockSignature.new(nil,
          :request_options => {:get => {'timestamp' => Time.now.to_i-86400}}
        )
        signature.should_not be_valid_timestamp
      end

      it "invalidates a future timestamp" do
        signature = Signature::MockSignature.new(nil,
          :request_options => {:get => {'timestamp' => Time.now.to_i+86400}}
        )
        signature.should_not be_valid_timestamp
      end

      it "allows setting the valid timestamp range" do
        signature = Signature::MockSignature.new(nil,
          :request_options => {:get => {'timestamp' => Time.now.to_i-5}}
        )
        signature.valid_timestamp_range = ((Time.now.to_i-4)..(Time.now.to_i+4))
        signature.should_not be_valid_timestamp
      end

      it "sets the default offset range to 5 minutes" do
        signature = Signature::MockSignature.new
        signature.valid_timestamp_range.should == ((Time.now.to_i-300)..(Time.now.to_i+300))
      end
    end


    describe "escape" do
      before(:each) do
        @signature = Signature::MockSignature.new
      end

      it "uses %20 to encode a space" do
        @signature.send(:escape, 'foo bar').should == 'foo%20bar'
      end

      it "uses uppercase hex encoding" do
        @signature.send(:escape, 'foo*bar').should == 'foo%2Abar'
      end

      it "does not encode characters in the unreserved character set" do
        @signature.send(:escape, 'abcABC012._-~').should == 'abcABC012._-~'
      end
    end


    describe "unescape" do
      before(:each) do
        @signature = Signature::MockSignature.new
      end

      it "decodes an escaped string" do
        @signature.send(:unescape, 'foo%2Abar%2B').should == 'foo*bar+'
      end

      it "does not change '+' into a space" do
        @signature.send(:unescape, 'foo+bar').should == 'foo+bar'
      end
    end

  end
end
