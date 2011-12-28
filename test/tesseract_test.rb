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
        Tesseract::Process.new(TEST_FILE, :check_deps => true)
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
        Tesseract::Process.new(TEST_FILE, :check_deps => true)
      end
    end
  end

  context "dependency tesseract fails" do
    setup do
      Tesseract::DependencyChecker.expects(:run_cmd).with("which tesseract").returns('').once
    end
    should "throw exception" do
      assert_raises Exception, Tesseract::DependencyChecker::TESSERACT_ERROR do
        Tesseract::Process.new(TEST_FILE, :check_deps => true)
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
    should "have lang of eng" do
      assert_equal :eng, @tess.lang
    end
    should "generate a valid convert command" do
      expected = "convert #{TEST_FILE} derp"
      result = @tess.generate_convert_command('derp')
      assert_equal expected, result
    end
  end

  context "tesseract convert options" do
    should "generate a valid convert command with input options" do
      options = {:convert_options => {:input => ['-size 120x120']}}
      tess = Tesseract::Process.new(TEST_FILE, options)
      expected = "convert -size 120x120 #{TEST_FILE} derp"
      result = tess.generate_convert_command('derp')
      assert_equal expected, result
    end
    should "generate a valid convert command with output options" do
      options = {:convert_options => {:output => ['-resize 120x120']}}
      tess = Tesseract::Process.new(TEST_FILE, options)
      expected = "convert #{TEST_FILE} -resize 120x120 derp"
      result = tess.generate_convert_command('derp')
      assert_equal expected, result
    end
    should "generate a valid convert command with input and output options" do
      options = {
        :convert_options => {
          :input => ['-size 120x120'],
          :output => ['-resize 140x140']
        }
      }
      tess = Tesseract::Process.new(TEST_FILE, options)
      expected = "convert -size 120x120 #{TEST_FILE} -resize 140x140 derp"
      result = tess.generate_convert_command('derp')
      assert_equal expected, result
    end

    context "tesseract invalid commands" do
      should "raise an exception when convert could not be executed" do
        options = {:convert_command => "derp"}
        tess = Tesseract::Process.new(TEST_FILE, options)
        assert_raises RuntimeError do
          tess.to_s
        end
      end
      should "raise an exception when tesseract could not be executed" do
        options = {:tesseract_command => "derp"}
        tess = Tesseract::Process.new(TEST_FILE, options)
        assert_raises RuntimeError do
          tess.to_s
        end
      end
    end
  end

  context "tesseract diff lang" do
    setup do
      @tess = Tesseract::Process.new(TEST_FILE, {:lang => :butts})
    end
    should "have lang of butts" do
      assert_equal :butts, @tess.lang
    end
  end

  context "tesseract configs" do
    setup do
      config = {:chop_enable => 0}
      @tess = Tesseract::Process.new(TEST_FILE, {:tesseract_options => config})
    end
    should "return text" do
      assert !@tess.to_s.empty?
    end
    should "have lang of eng" do
      assert_equal :eng, @tess.lang
    end
  end
end
