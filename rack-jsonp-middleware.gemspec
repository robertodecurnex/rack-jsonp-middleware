Gem::Specification.new do |s|
  s.name	= 'rack-jsonp-middleware'
  s.version	= '0.0.10'
  s.authors	= ['Roberto Decurnex']
  s.description	= 'A Rack JSONP middleware'
  s.summary	= 'rack-jsonp-middleware-0.0.5'
  s.email	= 'decurnex.roberto@gmail.com'
  s.homepage    = 'http://robertodecurnex.github.com/rack-jsonp-middleware'

  s.platform    = Gem::Platform::RUBY

  s.add_dependency 'rack', '>= 0'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rspec', '>= 1.3.0'
  s.add_development_dependency 'rake', '>= 0'

  s.rubygems_version	= '1.3.7'
  s.files		= [
    'README.md',
    'lib/rack/jsonp.rb'
  ]
  s.require_path	= 'lib'
end
