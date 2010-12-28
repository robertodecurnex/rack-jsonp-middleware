require 'spec_helper.rb'

describe Rack::JSONP do

  before :each do 
    @response_status = 200
    @response_headers = {
     'Content-Type' => 'application/json', 
     'Content-Length' => '15',
    }
    @response_body = ['{"key":"value"}']

    @app = lambda do
      [@response_status, @response_headers, @response_body]
    end
    
    @callback = 'J50Npi.success'
  end
  
  describe 'when a valid jsonp request is made' do
   
    before :each do
      @request = Rack::MockRequest.env_for('/action.jsonp', :params => "callback=#{@callback}")
      @jsonp_response = Rack::JSONP.new(@app).call(@request)
      @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
    end

    it 'should not modify the response status code' do
      @jsonp_response_status.should equal @response_status
    end

    it 'should update the response content length to the new value' do
      @jsonp_response_headers['Content-Length'].should == '32'
    end

    it 'should set the response content type as application/javascript' do
      @jsonp_response_headers['Content-Type'].should == 'application/javascript'
    end

    it 'should wrap the response body in the Javasript callback' do
      @jsonp_response_body.should == ["#{@callback}(#{@response_body});"]
    end

  end

  describe 'when a jsonp request is made wihtout a callback parameter present' do
  
    before :each do
      @request = Rack::MockRequest.env_for('/action.jsonp')
      @jsonp_response = Rack::JSONP.new(@app).call(@request)
      @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
    end

    it 'should set the response status to 400' do
      @jsonp_response_status.should equal 400
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
      @jsonp_response = Rack::JSONP.new(@app).call(@request)
      @jsonp_response_status, @jsonp_response_headers, @jsonp_response_body = @jsonp_response
    end

    it 'should not modify the response status' do
      @jsonp_response_status.should equal @response_status
    end

    it 'should not modify the response headers' do
      @jsonp_response_headers.should equal @response_headers
    end

    it 'should not modify the response body' do
      @jsonp_response_body.should equal @response_body
    end

  end

end
