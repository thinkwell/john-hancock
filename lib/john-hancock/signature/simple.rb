require 'digest/md5'

module JohnHancock::Signature

  # Signs a URL using three HTTP headers:
  #   X-Api-Key
  #   X-Api-Timestamp
  #   X-Api-Signature
  #
  # The signature is the MD5 hash (expressed as a 32 digit hexadecimal number)
  # of a string comprised of the following elements concatenated together:
  #
  #   * Shared Secret
  #   * Public Key
  #   * URL path (everything between the domain name and question mark beginning
  #     with the query string)
  #   * Current UTC timestamp (seconds since midnight, January 1, 1970)
  #
  # For example:
  #   Api Key:       1234567890
  #   Shared Secret: MySecret
  #   Timestamp:     1294870227
  #   Request:       GET http://api.example.com/foo/bar/1.json?param=test
  #
  #   String to hash:
  #   MySecret1234567890/foo/bar/1.json1294870227
  #
  #   Signature:
  #   2ef24e5b8c1dedc23240fb564874c7a6
  #
  #   Headers appended to the HTTP request:
  #   X-Api-Key: 1234567890
  #   X-Api-Timestamp: 1294870227
  #   X-Api-Signature: 2ef24e5b8c1dedc23240fb564874c7a6
  #
  class Simple < JohnHancock::Signature::Base

    attr_accessor :key_header, :timestamp_header, :signature_header

    def initialize(request, options={}, &block)
      @key_header = options.delete(:key_header) || 'X-Api-Key'
      @timestamp_header = options.delete(:timestamp_header) || 'X-Api-Timestamp'
      @signature_header = options.delete(:signature_header) || 'X-Api-Signature'
      super(request, options, &block)
    end


    def signature_base_string
      "#{secret}#{key}#{path}#{timestamp.to_i}"
    end


    def signature
      Digest::MD5.hexdigest(signature_base_string)
    end

    def id_hash
      {:id => key}
    end



    def key
      request.headers[key_header]
    end


    def timestamp
      request.headers[timestamp_header]
    end


    def request_signature
      request.headers[signature_header]
    end


  private

    def path
      request.path.to_s == '' ? '/' : request.path
    end

  end
end
