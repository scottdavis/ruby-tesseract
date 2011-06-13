require 'test_helper'

class TesseractTest < Test::Unit::TestCase
  TEST_FILE = File.join(File.dirname(__FILE__), 'photo.jpeg')
  context "dependency os check fails windows" do
    setup do
      @old_val = RUBY_PLATFORM
      silence_stream(STDERR) { Object.const_set("RUBY_PLATFORM", 'windows') }
    end
    should "throw exception" do
      assert_raises Exception, Tesseract::DependencyChecker::OS_ERROR do
        Tesseract::Process.new(TEST_FILE)
      end
    end
    teardown do
      silence_stream(STDERR) { Object.const_set("RUBY_PLATFORM", @old_val) }
    end
  end
  
  context "dependency imagemagic fails" do
    setup do
      Tesseract::DependencyChecker.expects(:run_cmd).with("which tesseract").returns('foo').once
      Tesseract::DependencyChecker.expects(:run_cmd).with("which convert").returns('').once
    end
    should "throw exception" do
      assert_raises Exception, Tesseract::DependencyChecker::IMAGE_MAGICK_ERROR do
        Tesseract::Process.new(TEST_FILE)
      end
    end
  end
  
  context "dependency tesseract fails" do
    setup do
      Tesseract::DependencyChecker.expects(:run_cmd).with("which tesseract").returns('').once
    end
    should "throw exception" do
      assert_raises Exception, Tesseract::DependencyChecker::TESSERACT_ERROR do
        Tesseract::Process.new(TEST_FILE)
      end
    end
  end
  
  context "tesseract" do
    setup do
      @tess = Tesseract::Process.new(TEST_FILE)
    end
    should "return text" do
      assert !@tess.to_s.empty?
    end
    should "hanve lang of eng" do
      assert_equal 'eng', @tess.lang
    end
  end
  
  context "tesseract diff lang" do
    setup do
      @tess = Tesseract::Process.new(TEST_FILE, {:lang => 'butts'})
    end
    should "have lang of butts" do
      assert_equal 'butts', @tess.lang
    end
  end
  
  context "tesseract configs" do
    setup do
      @tess = Tesseract::Process.new(TEST_FILE, {:chop_enable=>0})
    end
    should "return text" do
      assert !@tess.to_s.empty?
    end
    should "hanve lang of eng" do
      assert_equal 'eng', @tess.lang
    end
  end
  
end