# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tesseract/version"

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = %q{tesseract}
  s.version = Tesseract::VERSION
  s.platform  = Gem::Platform::RUBY

  s.authors = ["Scott Davis", "Martin Samson"]
  s.description = %q{Ruby wrapper for google tesseract}
  s.summary = %q{Ruby wrapper for google tesseract}
  s.email = %q{jetviper21@gmail.com}
  s.date = Date.today.to_s
  s.files = ['lib/tesseract.rb', 'lib/tesseract/process.rb', 'lib/tesseract/file_handler.rb', 'lib/tesseract/dependency_checker.rb']
  s.files += ['lib/tesseract/version.rb']
  s.require_path = 'lib'
  s.homepage = %q{http://github.com/scottdavis/ruby-tesseract}
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.required_ruby_version = '>= 1.9.0'
end
