module Rack
  class JSONP
    include Rack::Utils

    def initialize(app)
      @app = app
    end


    def call(env)
      request = Rack::Request.new(env)
      requesting_jsonp = Pathname(request.env['REQUEST_PATH']).extname =~ /^\.jsonp$/i
      callback = request.params['callback']

      return [400,{},[]] if requesting_jsonp && !callback

      env['REQUEST_URI'].sub!(/\.jsonp/i, '.json') if requesting_jsonp
      
      status, headers, response = @app.call(env)

      if requesting_jsonp
        response.body = "#{callback}(#{response.body});"
        headers['Content-Length'] = response.body.length.to_s
        headers['Content-Type'] = 'application/javascript'
      end

      [status, headers, response]
    end
  end
end