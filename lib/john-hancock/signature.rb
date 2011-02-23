module JohnHancock
  module Signature

    def self.klass(algorithm)
      return algorithm if algorithm.is_a?(Base)
      raise UnknownAlgorithm unless algorithm && algorithm.to_s != ""

      begin
        klass = "JohnHancock::Signature::#{algorithm.to_s.camelize}".constantize
      rescue NameError
      end
      raise UnknownAlgorithm, algorithm.to_s unless klass && klass.class == Class

      klass
    end

    def self.algorithm_exists?(algorithm)
      self.klass(algorithm) && true
    rescue UnknownAlgorithm
      false
    end

    def self.build(algorithm, request, options = {}, &block)
      klass = self.klass(algorithm)
      request = RequestProxy.proxy(request)
      klass.new(request, options, &block)
    end

    def self.sign!(algorithm, request, options = {}, &block)
      self.build(algorithm, request, options, &block).sign!
    end

    def self.verify(algorithm, request, options = {}, &block)
      self.build(algorithm, request, options, &block).verify
    end

    class UnknownAlgorithm < Exception; end
  end
end
