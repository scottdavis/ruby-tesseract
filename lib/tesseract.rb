path = File.join(File.dirname(__FILE__), 'tesseract')
['dependency_checker', 'file_handler', 'process'].each do |f|
  require File.expand_path(File.join(path, f))
end
require 'pathname'
require 'digest/md5'
require 'shellwords'

module Tesseract

end
