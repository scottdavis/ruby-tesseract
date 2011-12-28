require 'pathname'
require 'tempfile'
module Tesseract
  class FileHandler
    @tempfiles = []
    def self.create_temp_file(filename)
      file = Pathname.new(Dir::tmpdir).join(filename)
      @tempfiles << file
      return file
    end
    def self.cleanup!
      @tempfiles.each do |file|
        File.unlink(file.to_s) if File.exists?(file.to_s)
      end
    end
  end
end
