require 'uri'

module JohnHancock::Signature
  class Base

    attr_accessor :options, :request, :valid_timestamp_range, :secret

    def initialize(request, options={}, &block)
      raise TypeError, "Request must be a JohnHancock::RequestProxy" unless request.kind_of?(JohnHancock::RequestProxy::Base)
      @request = request
      @valid_timestamp_range = options.delete(:valid_timestamp_range) || ((Time.now.to_i-300)..(Time.now.to_i+300))
      @secret = options.delete(:secret)
      @options = options
    end


    ##############################################
    #
    # Subclasses MUST override:
    #

    def signature
      raise NotImplementedError, "Must be implemented by subclasses"
    end

    def signature_base_string
      raise NotImplementedError, "Must be implemented by subclasses"
    end

    def id_hash
      h = {}
      h[:id] = request.parameters[:id] if request.parameters.include?(:id)
      h
    end

    #
    ##############################################
    #


    def sign!
      # TODO
      raise NotImplementedError, "Coming soon!"
    end


    def timestamp
      request.parameters.include?('timestamp') ? request.parameters['timestamp'].to_i : nil
    end


    def timestamp=(ts)
      # TODO!
      raise NotImplementedError, "Coming soon!"
    end


    # Returns the existing signature for the request.
    #
    # This does not compute the signature, use +signature+ for that.  It may return
    # nil if no signature exists.
    def request_signature
      request.parameters['signature']
    end


    def valid?
      valid_signature? && valid_timestamp?
    end


    # Compares the existing signature for the request with the calculated
    # signature.
    def valid_signature?
      signature == request_signature
    end


    def valid_timestamp?
      valid_timestamp_range.include?(timestamp.to_i)
    end


    def to_s
      signature
    end


  private

    # http://tools.ietf.org/html/rfc5849#section-3.6
    def unreserved_characters
      "-a-zA-Z0-9._~"
    end


    def uri_parser
      URI::Parser.new(:UNRESERVED => unreserved_characters, :RESERVED => "")
    end


    # Escape +value+ by URL encoding all non-reserved character.
    def escape(value)
      uri_parser.escape(value.to_s)
    rescue ArgumentError
      uri_parser.escape(value.to_s.force_encoding(Encoding::UTF_8))
    end


    def unescape(value)
      uri_parser.unescape(value.gsub('+', '%2B'))
    end

  end
end
