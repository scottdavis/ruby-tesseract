require 'shellwords'
module Tesseract
  class Process

    attr_reader :image

    CONVERT_COMMAND = 'convert'
    TESSERACT_COMMAND = 'tesseract'
    # Initialize a Tesseract translation process
    # image_name is the file to translate
    # options can be of the following:
    # * tesseract_options Hash of options for tesseract
    # * convert_options Array of options for convert
    # * lang Image input language (eng, fra, etc. )
    # * convert_command Convert binary name/path
    # * tesseract_command Tesseract binary name/path
    # * check_deps Boolean value. If true, verifies dependencies. Defaults to false
    def initialize(image_name, options = {})
      defaults = {
        :tesseract_options => {},
        :convert_options => {:input => [], :output => []},
        :lang => :eng,
        :convert_command => CONVERT_COMMAND,
        :tesseract_command => TESSERACT_COMMAND,
        :check_deps => false
      }
      @out = nil
      @image = Pathname.new(image_name)
      @hash = Digest::MD5.hexdigest("#{@image}-#{Time.now}")
      @options = defaults.merge! options
      DependencyChecker.check! if @options[:check_deps]
    end

    def to_s
      @out ||= process!
    end

    # Process the image into text.
    def process!
      temp_image = to_tiff
      begin
        text = tesseract_translation(temp_image)
      rescue IOError
        raise
      ensure
        FileHandler.cleanup!
      end
      text.gsub(/^\//, '')
    end

    # Converts the source image to a tiff file.
    def to_tiff
      temp_file = FileHandler.create_temp_file("#{@hash}.tif")

      cmd = [@options[:convert_command]]
      input_opt = @options[:convert_options][:input]
      output_opt = @options[:convert_options][:output]

      cmd << input_opt unless input_opt.empty?
      cmd << @image.to_s
      cmd << output_opt unless output_opt.empty?
      cmd << temp_file.to_s

      system Shellwords.join(cmd)
      temp_file
    end

    # Translate a tiff file into text
    def tesseract_translation(image_file)
      temp_text_file = FileHandler.create_temp_file(@hash.to_s)
      config_file = write_configs
      txt_file = "#{temp_text_file}.txt"
      system [@options[:tesseract_command], image_file.to_s, temp_text_file.to_s, "-l #{@options[:lang]}", config_file, "&> /dev/null"].join(' ')
      out = File.read(txt_file)
      File.unlink txt_file
      out
    end
    # Writes Tesseract configuration for the current source file
    def write_configs
      return '' if @options[:tesseract_options].empty?
      path = FileHandler.create_temp_file("#{@hash}.config")
      File.open(path, "w+") do |f|
        @options[:tesseract_options].each { |k,v| f << "#{k} #{v}\n" }
      end
      path
    end
  end
end
