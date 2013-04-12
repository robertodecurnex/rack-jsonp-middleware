# Creates and push coverage reports
# This MUST be done before any other requrie in order to get the reports.
require 'coveralls'
Coveralls.wear!
#########################################################################

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack'
require 'rack/jsonp'
