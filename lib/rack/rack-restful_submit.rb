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

    def rewrite_request(env, prefixed_uri)
      # rails 3 expects that relative_url_root is not part of
      # requested uri, this fix also expects that mapping['url']
      # contains only path (not full url)
      uri = prefixed_uri.sub(/^#{Regexp.escape(env['SCRIPT_NAME'])}\//, '/')

      env['PATH_INFO'], env['QUERYSTRING'] = uri.split("?",2)
    end

    def rewrite_method(env, method)
      if HTTP_METHODS.include?(method)
        env["rack.methodoverride.original_method"] = env["REQUEST_METHOD"]
        env["REQUEST_METHOD"] = method
      end
    end

  end
end

