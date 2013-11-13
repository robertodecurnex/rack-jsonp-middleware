# encoding: utf-8

require 'spec_helper.rb'

describe Rack::JSONP do
  
  [true, false].each do |path_prefix_used|
    describe "#{path_prefix_used ? 'with' : 'without'} path_prefix option used" do

      before :each do
        @response_status = 200
        @response_headers = {
         'Content-Type' => 'application/json',
         'Content-Length' => '15',
        }
        @response_body = ['{"key":"value"}']

        @app = lambda do |params|
          [@response_status, @response_headers, @response_body]
        end

        @callback = 'J50Npi.success'

        @path_prefix, @path = *if path_prefix_used
          ["/api", "/api/v1/action"]
        else
          [nil,    "/action"]
        end
      end

      describe 'when a valid jsonp request is made' do

        before :each do
          @request = Rack::MockRequest.env_for("#{@path}.jsonp?callback=#{@callback}")
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should not modify the response status code' do
          @jsonp_response_status.should == @response_status
        end

        it 'should update the response content length to the new value' do
          @jsonp_response_headers['Content-Length'].should == '32'
        end

        it 'should set the response content type as application/javascript' do
          @jsonp_response_headers['Content-Type'].should == 'application/javascript'
        end

        it 'should wrap the response body in the Javasript callback' do
          @jsonp_response_body.should == ["#{@callback}(#{@response_body.first});"]
        end

      end

      describe 'when a valid jsonp request is made with multibyte characters' do

        before :each do
          @response_headers['Content-Type'] = 'application/json; charset=utf-8'
          @response_body = ['{"key":"√alue"}']
          @request = Rack::MockRequest.env_for("#{@path}.jsonp?callback=#{@callback}")
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should not modify the response status code' do
          @jsonp_response_status.should == @response_status
        end

        it 'should update the response content length to the new value' do
          @jsonp_response_headers['Content-Length'].should == '34'
        end

        it 'should set the response content type as application/javascript without munging the charset' do
          @jsonp_response_headers['Content-Type'].should == 'application/javascript; charset=utf-8'
        end

        it 'should wrap the response body in the Javasript callback' do
          @jsonp_response_body.should == ["#{@callback}(#{@response_body.first});"]
        end

      end


      describe 'when a jsonp request is made wihtout a callback parameter present' do

        before :each do
          @request = Rack::MockRequest.env_for('/action.jsonp')
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should set the response status to 400' do
          @jsonp_response_status.should == 400
        end

        it 'should return an empty body' do
          @jsonp_response_body.should == []
        end

        it 'should return empty headers' do
          @jsonp_response_headers.should == {}
        end

      end

      describe 'when a jsonp request is made with an invalid callback' do

        before :each do
          @callback = "alert('window.cookies');cb"
          @request = Rack::MockRequest.env_for("#{@path}.jsonp?callback=#{@callback}")
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should set the response status to 400' do
          @jsonp_response_status.should == 400
        end

        it 'should return an empty body' do
          @jsonp_response_body.should == []
        end

        it 'should return empty headers' do
          @jsonp_response_headers.should == {}
        end
      end

      describe 'when a non jsonp request is made' do

        before :each do
          @request = Rack::MockRequest.env_for('/action.json')
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should not modify the response status' do
          @jsonp_response_status.should == @response_status
        end

        it 'should not modify the response headers' do
          @jsonp_response_headers.should == @response_headers
        end

        it 'should not modify the response body' do
          @jsonp_response_body.should == @response_body
        end

      end

      describe 'when the original response is not json' do

        before :each do
          @response_status = 403
          @response_headers = {
           'Content-Type' => 'text/html',
           'Content-Length' => '1'
          }
          @response_body = ['']

          @request = Rack::MockRequest.env_for("#{@path}.jsonp?callback=#{@callback}")
          @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
          @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
        end

        it 'should not modify the response body' do
          @jsonp_response_body.should == @response_body
        end

        it 'should not odify the headers Content-Type' do
          @jsonp_response_headers['Content-Type'].should == @response_headers['Content-Type']
        end

        it 'should not modify the headers Content-Lenght' do
          @jsonp_response_headers['Content-Lenght'].should == @response_headers['Content-Lenght']
        end

      end
      
      if path_prefix_used

        describe "with nonmatching request path" do

          before do
            @request = Rack::MockRequest.env_for("/different/path/action.jsonp?callback=#{@callback}")
            @jsonp_response = Rack::JSONP.new(@app, @path_prefix).call(@request)
            @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
          end

          it 'should set the response status to 400' do
            @jsonp_response_status.should == 400
          end

          it 'should return an empty body' do
            @jsonp_response_body.should == []
          end

          it 'should return empty headers' do
            @jsonp_response_headers.should == {}
          end
        end
      end
    end
  end
end
