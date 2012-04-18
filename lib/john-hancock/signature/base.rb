require 'uri'

module JohnHancock::Signature
  class Base

    attr_accessor :options, :request, :valid_timestamp_range

    def initialize(request, options={}, &block)
      raise TypeError, "Request must be a JohnHancock::RequestProxy" unless request.kind_of?(JohnHancock::RequestProxy::Base)
      @request = request

      options = {
        'valid_timestamp_range' => ((Time.now.to_i-300)..(Time.now.to_i+300))
      }.merge(options)

      # Configure the object
      options.each do |key, val|
        self.send("#{key}=", val) if self.respond_to?("#{key}=")
      end

      read_request_attributes

      # Re-apply all options after reading request attributes
      @options = options.inject({}) do |otherOptions, (key, val)|
        self.respond_to?("#{key}=") ? self.send("#{key}=", val) : otherOptions[key] = val
        otherOptions
      end
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

    # Subclasses MAY override

    def id_hash
      h = {}
      h[:id] = request.parameters[:id] if request.parameters.include?(:id)
      h
    end

    def valid_format?
      h = id_hash
      h && h.is_a?(Hash) && !h.values.compact.empty?
    end

    def write_request_attributes
    end

    def read_request_attributes
    end

    #
    ##############################################
    #


    def sign!
      self.timestamp = Time.now.to_i if timestamp.nil?
      self.request_signature = signature
      write_request_attributes
    end


    def timestamp
      request.parameters.include?('timestamp') ? request.parameters['timestamp'].to_i : nil
    end


    def timestamp=(ts)
      request.query_parameters['timestamp'] = ts
    end


    # Returns the existing signature for the request.
    #
    # This does not compute the signature, use +signature+ for that.  It may return
    # nil if no signature exists.
    def request_signature
      request.parameters['signature']
    end


    def request_signature=(signature)
      request.query_parameters['signature'] = signature
    end


    def valid?
      valid_format? && valid_signature? && valid_timestamp?
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

    def reserved_characters
      URI::REGEXP::PATTERN::RESERVED
    end


    # http://tools.ietf.org/html/rfc5849#section-3.6
    def unreserved_characters
      "-a-zA-Z0-9._~"
    end


    def unsafe_regex
      Regexp.new("[^#{unreserved_characters}#{reserved_characters}]", false, 'N').freeze
    end


    # Escape +value+ by URL encoding all non-reserved character.
    def escape(value)
      URI.escape(value.to_s, unsafe_regex)
    rescue ArgumentError
      URI.escape(value.to_s.force_encoding(Encoding::UTF_8))
    end


    def unescape(value)
      URI.unescape(value.gsub('+', '%2B'))
    end

  end
end
