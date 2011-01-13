module JohnHancock
  module RequestProxy
    class Headers < ::Hash

      def initialize(*args)
        if args.size == 1 && args[0].is_a?(Hash)
          super()
          update(args[0])
        else
          super
        end
      end

      def [](header_name)
        if include?(header_name)
          super
        else
          super(env_name(header_name))
        end
      end

      private
        # Converts a HTTP header name to an environment variable name.
        def env_name(header_name)
          "HTTP_#{header_name.upcase.gsub(/-/, '_')}"
        end
    end
  end
end
