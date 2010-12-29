require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
Rake::TestTask.new do |t|
  t.libs << "tesseract"
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end