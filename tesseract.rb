Dir["tesseract/*.rb"].each { |file| require file }
require 'pathname'
require 'digest/md5'
module Tesseract
  class Process
    attr_reader :image
    attr_accessor :lang
    CONVERT_COMMAND = 'convert'
    TESSERACT_COMMAND = 'tesseract'
  
    def initialize(image_name, options = {})
      DependencyChecker.check!
      @image = Pathname.new(image_name)
      @hash = Digest::MD5.hexdigest("#{@image}-#{Time.now}")
      @lang = options[:lang].nil? ? 'eng' : options.delete(:lang)
      @options = options
    end
  
    def to_s
      @out ||= process!
    end
  
    def process!
      temp_image = to_tiff
      text = tesseract_translation(temp_image)
      FileHandler.cleanup!
      text.gsub(/^\//, '')
    end
  
    def to_tiff
      temp_file = FileHandler.create_temp_file("#{@hash}.tif")
      system [CONVERT_COMMAND, image, temp_file].join(" ")
      temp_file
    end
  
    def tesseract_translation(image_file)
      temp_text_file = FileHandler.create_temp_file("#{@hash}")
      config_file = write_configs
      system [TESSERACT_COMMAND, image_file, temp_text_file, "-l #{@lang}", config_file, "&> /dev/null"].join(" ")
      File.read("#{temp_text_file}.txt")
    end
    
    def write_configs
      return '' if @options.empty?
      path = FileHandler.create_temp_file("#{@hash}.config")
      File.open(path, "w+") do |f|
        @options.each { |k,v| f << "#{k} #{v}\n" }
      end
      path
    end
    
  end
  
end