# Ruby Tesseract

This is a library for using the tesseract OCR in ruby applications

## Dependcies

1. [Terreract] (http://code.google.com/p/tesseract-ocr/)
2. [ImageMagick](http://www.imagemagick.org/script/index.php) - Note the command line program `convert` needs to be accessible to ruby
3.) *nix based operating system

##Usage

*Please Note the default language is english*

    tess = Tesseract::Process.new("photo.jpg")
    tess.to_s
    
Config options are also supported

    tess = Tesseract::Process.new("photo.jpg", {:lang => 'some language', :chop_enable => 0})
    tess.to_s
    