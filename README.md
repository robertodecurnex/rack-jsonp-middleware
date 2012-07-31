# rack-jsonp-middleware - ![Travis CI Status](http://travis-ci.org/robertodecurnex/rack-jsonp-middleware.png) - ![Gemnasium Dependencies Status](https://gemnasium.com/robertodecurnex/rack-jsonp-middleware.png)

A Rack JSONP middleware

## Overview

This is a customized implementation of a JSONP middleware. 

The main difference with the rest of them is that this one will add JSONP support to any of your JSON calls but only when the extension name '.jsonp' is present.

Since 'callback' is a really generic parameter name if someone wants to get a JSONP response they must request it explicitly.

Btw, don't forget to give a try to [J50Nπ](https://github.com/robertodecurnex/J50Npi) (a pure JS JSONP helper), they make a lovely couple together :P

## Authors

Roberto Decurnex (nex.development@gmail.com)

## Contributors

* [rwilcox](https://github.com/rwilcox "rwilcox profile")
* [amiel](https://github.com/amiel "amiel profile")

## Install

If you are using Bundler you can easily add the following line to your Gemfile:
    
    gem 'rack-jsonp-middleware'

Or you can just install it as a ruby gem by running:
    
    $ gem install rack-jsonp-middleware

## Configuration

### Rails 3

In your `config/application.rb` file add:
    
    require 'rack/jsonp'

And, within the config block:
    
    config.middleware.use Rack::JSONP

Here is an exelent example of this - [Rails 3 Configuration Example](https://github.com/rwilcox/rack_jsonp_example/commit/809c2e3d4470b694ba1a98c09f2aa07115f433e5 "Rails 3 Configuration Example")

Thank you [rwilcox](https://github.com/rwilcox "rwilcox profile")! 

### Rails 2

Same as for Rails 3 but modifying the `config/environment.rb` file instead.

### Rack Apps

In your `config.ru` file add the following lines:
    
    require 'rack/jsonp'
    use Rack::JSONP

## Download

You can also clone the project with Git by running:
    $ git clone git://github.com/robertodecurnex/rack-jsonp-middleware

## Examples

Given that http://domain.com/action.json returns the following:
    {"key":"value"}
With the following Content-Type:
    application/json

Then http://domain.com/action.jsonp?callback=J50Npi.success will return the following:
    J50Npi.success({"key":"value"})
With the following Content-Type:
    application/javascript

But http://domain.com/action.json?callback=J50Npi.sucess will still returns the following:
    {"key":"value"}
With the following Content-Type:
    application/json
