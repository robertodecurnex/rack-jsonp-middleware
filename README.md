# rack-jsonp-middleware

A Rack JSONP middleware

## Overview

This is a customized implementation of a JSONP middleware. 

The main difference with the rest of them is that this one will add JSONP support to any of your JSON calls but only when the extension name '.jsonp' is present.

Since 'callback' is a really generic parameter name if someone wants to get a JSONP response they must request it explicitly.

## Examples

Given that ...
    http://domain.com/action.json

Returns something like ...
    {"key":"value"}

With Content-Type ...
    application/json

Then ...
    http://domain.com/action.jsonp?callback=success

Will return ...
    success({"key":"value"})

With Content-Type ...
    application/javascript

But ...
    http://domain.com/action.json?callback=sucess

Will still returns ...
    {"key":"value"}

With Content-Type ...
    application/json

## Notes

[To be improved] Calling "something.jsonp" without a "callback" will return an empty 400 response
