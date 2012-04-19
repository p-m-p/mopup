begin
  require 'rubygems'
  gem 'mopup'
rescue LoadError
end

require 'test/unit'
require 'mopup'

class MopupTest < Test::Unit::TestCase

  def setup
    @mopup = Mopup.new
  end

  def test_clean
    clean = @mopup.clean('Hello mopup!      ')
    assert_no_match /\s+$/, clean
  end

  def test_clean_translate_tabs
    @mopup.options[:translate_tabs_to_spaces] = true
    dirty = '    Hello mopup!'
    clean = '    Hello mopup!'
    assert @mopup.clean(dirty) == clean
  end

  def test_clean_text
    @mopup.options[:translate_tabs_to_spaces] = true
    dirty = %q{
          This is some text
      With somwe dirty lines
        that need cleaning
    }
    @mopup.clean_text(dirty) do |line|
      assert_no_match /\t/, line
      assert_no_match /\s+$/, line
    end
  end

end
