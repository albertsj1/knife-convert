$:.unshift(File.dirname(__FILE__) + '/lib')
require 'convert/version'

Gem::Specification.new do |s|
  s.name = "knife-convert"
  s.version = Chef::Convert::VERSION
  s.license = 'Apache 2.0'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["LICENSE"]
  s.summary = "knife plugin for converting roles and environment files to recipes"
  s.description = s.summary
  s.author = "John Alberts"
  s.email = "john.m.alberts@gmail.com"
  s.homepage = "http://github.com/albertsj1/knife-convert"

  s.add_dependency "mixlib-cli", ">= 1.2.2"
  s.add_dependency 'chef'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'

  s.require_path = 'lib'
  s.files = %w(LICENSE README.md Rakefile) + Dir.glob("{lib,spec}/**/*")
end
