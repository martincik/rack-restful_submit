module Rack
  class RestfulSubmit < MethodOverride

    REWRITE_KEYWORD = '__rewrite'.freeze
    REWRITE_MAP = '__map'.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["REQUEST_METHOD"] == "POST"
        req = Request.new(env)

        if req.params[REWRITE_KEYWORD] && req.params[REWRITE_MAP]
          action = req.params[REWRITE_KEYWORD].keys.first # Should be always just one.
          mapping = req.params[REWRITE_MAP][action]

          if mapping && mapping['url'] && mapping['method']
            rewrite(env, mapping['url'], mapping['method'])
          else
            return super(env)
          end
        else
          return super(env)
        end
      end

      @app.call(env)
    end

    private

    def rewrite(env, url, method)
      rewrite_request(env, url)
      rewrite_method(env, method)
    end

    def rewrite_request(env, uri)
      env['REQUEST_URI'] = uri
      if q_index = uri.index('?')
        env['PATH_INFO'] = uri[0..q_index-1]
        env['QUERYSTRING'] = uri[q_index+1..uri.size-1]
      else
        env['PATH_INFO'] = uri
        env['QUERYSTRING'] = ''
      end
    end

    def rewrite_method(env, method)
      if HTTP_METHODS.include?(method)
        env["rack.methodoverride.original_method"] = env["REQUEST_METHOD"]
        env["REQUEST_METHOD"] = method
      end
    end

  end
end

