module Rack

  class JSONP
    # Do not allow arbitrary Javascript in the callback.
    VALID_CALLBACK_PATTERN = /^[a-zA-Z0-9\._]+$/

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      requesting_jsonp = Pathname(request.env['PATH_INFO']).extname =~ /^\.jsonp$/i
      callback = request.params['callback']

      return [400,{},[]] if requesting_jsonp && (!callback || !callback.match(VALID_CALLBACK_PATTERN))

      if requesting_jsonp
        env['PATH_INFO'].sub!(/\.jsonp/i, '.json')
        env['REQUEST_URI'] = env['PATH_INFO']
      end

      status, headers, body = @app.call(env)

      if requesting_jsonp && headers['Content-Type'] && headers['Content-Type'].match(/application\/json/i)
        json = ""
        body.each { |s| json << s }
        body = ["#{callback}(#{json});"]
        headers['Content-Length'] = Rack::Utils.bytesize(body[0]).to_s
        headers['Content-Type'] = force_mime_type(headers['Content-Type'], 'application/javascript')
      end

      [status, headers, body]
    end

    def force_mime_type(content_type, mime_type)
      content_type_parts = (content_type || '').split(/;/)
      content_type_parts[0] = mime_type
      content_type_parts.join(';')
    end

  end

end
