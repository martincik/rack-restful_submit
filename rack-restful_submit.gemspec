# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name     = "rack-restful_submit"
  s.version  = "1.2.1"
  s.platform = Gem::Platform::RUBY
  s.authors  = ["Ladislav Martincik"]
  s.email    = ["ladislav.martincik@gmail.com"]
  s.homepage = "https://github.com/martincik/rack-restful_submit"
  s.summary  = %q(Allows RESTful routing without Javascript and multiple submit buttons)
  s.description = %q(Implements support of RESTful resources with Rails MVC when Javascript is off and bulk operations are required with multiple submit buttons.)
  s.required_rubygems_version = ">= 1.3.6"
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.add_dependency "rack", "~>1.3.0"
  s.add_development_dependency 'rspec', '~>2.6.0'
end

