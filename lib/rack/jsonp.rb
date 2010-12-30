module Rack

  class JSONP

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      requesting_jsonp = Pathname(request.env['PATH_INFO']).extname =~ /^\.jsonp$/i
      callback = request.params['callback']

      return [400,{},[]] if requesting_jsonp && !callback

      if requesting_jsonp
        env['PATH_INFO'].sub!(/\.jsonp/i, '.json')
        env['REQUEST_URI'] = env['PATH_INFO']
      end
      
      status, headers, body = @app.call(env)

      if requesting_jsonp && headers['Content-Type'] && headers['Content-Type'].match(/application\/json/i)
        json = ""
        body.each { |s| json << s }
        body = ["#{callback}(#{json});"]
        headers['Content-Length'] = body[0].length.to_s
        headers['Content-Type'] = 'application/javascript'
      end

      [status, headers, body]
    end

  end

end
