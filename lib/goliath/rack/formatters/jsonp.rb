module Goliath
  module Rack
    module Formatters
    
      # A middleware to wrap the response into a JSONP callback.
      #
      # @example
      #  use Goliath::Rack::JSONP
      #
      class JSONP
        include Goliath::Rack::AsyncMiddleware

        def post_process(env, status, headers, body)
          return [status, headers, body] unless env.params['callback']

          response = ""
          
          # do this for array-like things, but not for hash-like things
          if body.respond_to?(:each) && !body.respond_to?(:has_key)
            body.each { |s| response << s }
          else
            response = body
          end

          [status, headers, ["#{env.params['callback']}(#{response})"]]
        end
      end
      
    end
  end
end

