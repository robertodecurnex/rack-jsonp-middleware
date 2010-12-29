# rack-jsonp-middleware

A Rack JSONP middleware

## Overview

This is a customized implementation of a JSONP middleware. 

The main difference with the rest of them is that this one will add JSONP support to any of your JSON calls but only when the extension name '.jsonp' is present.

Since 'callback' is a really generic parameter name if someone wants to get a JSONP response they must request it explicitly.

Btw, don't forget to give a try to [J50Nπ](https://github.com/robertodecurnex/J50Npi) (a pure JS JSONP helper), they make a lovely couple together :P

## Authors

Roberto Decurnex (nex.development@gmail.com)

## Install

If you are using Bundler you can easily add the following line to your Gemfile:
    gem 'rack-jsonp-middleware'

Or you can just install it as a ruby gem by running:
    $ gem install rack-jsonp-middleware

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
    aplication/javascript

But http://domain.com/action.json?callback=J50Npi.sucess will still returns the following:
    {"key":"value"}
With the following Content-Type:
    application/json
