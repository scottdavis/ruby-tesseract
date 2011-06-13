require 'test/unit'
require 'test/unit/assertions'
require 'rubygems'
require 'shoulda'
require 'mocha'
require 'tesseract'
class Test::Unit::TestCase
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen('/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end
end