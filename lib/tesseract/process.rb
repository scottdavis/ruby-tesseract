module Tesseract
  class Process

    attr_reader :image
    attr_accessor :lang

    def initialize(image_name, options = {})
      defaults = {
        :tesseract_options => {},
        :convert_options => {},
        :lang => :eng,
        :convert_command => 'convert',
        :tesseract_command => 'tesseract',
        :check_deps => false
      }
      @image = Pathname.new(image_name)
      @hash = Digest::MD5.hexdigest("#{@image}-#{Time.now}")
      @options = defaults.merge! options
      DependencyChecker.check! if @options[:check_deps]
    end

    def to_s
      @out ||= process!
    end

    def process!
      temp_image = to_tiff
      text = tesseract_translation(temp_image)
      FileHandler.cleanup!
      # text.gsub(/^\//, '')
      text
    end

    def to_tiff
      tmp_name = "#{@hash}.tif"
      temp_file = FileHandler.create_temp_file(tmp_name)
      system Shellwords.join[@options[:convert_command], image, temp_file]
      temp_file
    end

    def tesseract_translation(image_file)
      temp_text_file = FileHandler.create_temp_file("#{@hash}")
      config_file = write_configs

      system Shellwords.join[@options[:tesseract_command], image_file, temp_text_file, "-l #{@lang}", config_file, "&> /dev/null"]
      File.read("#{temp_text_file}.txt")
    end

    def write_configs
      return '' if @options.empty?
      path = FileHandler.create_temp_file("#{@hash}.config")
      File.open(path, "w+") do |f|
        @options[:tesseract_options].each { |k,v| f << "#{k} #{v}\n" }
      end
      path
    end
  end
end
