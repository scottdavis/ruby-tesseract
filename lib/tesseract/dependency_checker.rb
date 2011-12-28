module Tesseract
  class DependencyChecker
    #putting these here so its easyer to test
    IMAGE_MAGICK_ERROR = "ImageMagick \"convert\" command not found! Make sure ImageMagick is installed and in the system path"
    TESSERACT_ERROR = "\"tesseract\" command not found! Make sure tesseract is installed and in the system path"
    OS_ERROR = "Only Unix Based enviroments are supported Mac, Linux, etc."

    def self.check!
      check_os!
      check_for_tesseract!
      check_for_imagemagick!
      true
    end

    private
    #for easy mocking
    def self.run_cmd(cmd)
      `#{cmd}`
    end

    def self.check_os!
      case ::RUBY_PLATFORM
        when /darwin/
          return true
        when /linux/, /unix/
          return true
      end
      raise Exception, OS_ERROR
    end

    def self.check_for_imagemagick!
      raise Exception, IMAGE_MAGICK_ERROR if run_cmd('which convert').empty?
    end

    def self.check_for_tesseract!
      raise Exception, TESSERACT_ERROR if run_cmd('which tesseract').empty?
    end

  end
end
