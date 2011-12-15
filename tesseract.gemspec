Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.name = %q{tesseract}
  s.version = Tesseract::VERSION
  s.platform  = Gem::Platform::RUBY

  s.authors = ["Scott Davis"]
  s.description = %q{Ruby wrapper for google tesseract}
  s.summary = %q{Ruby wrapper for google tesseract}
  s.email = %q{jetviper21@gmail.com}
  s.date = Date.today.to_s
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'tesseract'
  s.homepage = %q{http://github.com/scottdavis/ruby-tesseract}
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "bundler", ">= 1.0.0"
end