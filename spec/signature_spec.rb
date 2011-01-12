require 'spec_helper'

module JohnHancock
  describe Signature do

    describe 'self.klass' do
      it "returns a signature class for an algorithm string" do
        Signature.klass('mock_signature').should == Signature::MockSignature
      end

      it "returns a signature class for an algorithm symbol" do
        Signature.klass(:mock_signature).should == Signature::MockSignature
      end

      it "raises an error for an unknown algorithm" do
        expect { Signature.klass(:foobar) }.to raise_error(Signature::UnknownAlgorithm)
      end

      it "raises an error for an empty algorithm" do
        expect { Signature.klass('') }.to raise_error(Signature::UnknownAlgorithm)
      end
    end


    describe 'self.algorithm_exists?' do
      it "returns true for a known algorithm" do
        Signature.should be_algorithm_exists(:mock_signature)
      end

      it "returns false for an unknown algorithm" do
        Signature.should_not be_algorithm_exists('foobar')
      end
    end


    describe 'self.build' do
      before(:each) do
        @request = Mock::Request.new({})
      end

      it "returns a signature object" do
        Signature.build(:mock_signature, @request).should be_a(Signature::MockSignature)
      end

      it "raises an error for an unknown request" do
        expect { Signature.build(:simple, "foobar") }.to raise_error(RequestProxy::UnknownRequestType)
      end
    end


  end
end
