##
# Mops up trailing white space and optionally converts
# leading tabs to spaces
class Mopup

  require 'tempfile'
  require 'ptools'
  require 'fileutils'

  VERSION = '0.0.1'

##
# The clean-up options
#
# * +:translate_tabs_to_spaces+ Translate leading tabs to spaces
# * +:tab_stop+ Number of spaces to which tabs should be translated
#
  attr_reader :options

##
# == Examples
#
#  # To translate tabs to 2 spaces
#  Mopup.new :translate_tabs_to_spaces => true, :tab_stop => 2
#
  def initialize(options = nil)
    @options = {
      :translate_tabs_to_spaces => false,
      :tab_stop => 2
    }
    @options.merge!(options) if options
  end

##
# Cleans the whitespace in a line of text
#
# == Examples
#
#  mopup = Mopup.new
#  mopup.clean 'A dirty line of text to clean       ' #=> 'A dirty line of text to clean'
#
  def clean(line)
    if @options[:translate_tabs_to_spaces]
      line.gsub!(/\t/, ' ' * @options[:tab_stop])
    end
    line.rstrip!
    line
  end

# Returns a copy of text with the whitespace in each line cleaned up
  def clean_text(text)
    buffer = ''
    text.lines do |line|
      clean(line)
      yield(line) if block_given?
      buffer << line
    end
    buffer
  end

# Cleans each line in file located at +path+
  def clean_file(path)
    tmp = Tempfile.new('mopup')
    stat = File.stat(path)
    begin
      File.open(path) do |f|
        while line = f.gets
          clean(line)
          tmp.puts line
        end
      end
      tmp.close
      FileUtils.mv(tmp.path, path)
      File.chmod(stat.mode, path)
      File.chown(stat.uid, stat.gid, path)
    ensure
      tmp.close!
    end
  end

# Cleans each plain text file within the directory located at +path+
  def clean_dir(path, recurse = false, &block)
    Dir.foreach(path) do |entry|
      unless entry =~ /^\./
        full_path = path.chomp('/') + '/' + entry
        if File.file? full_path
          result = 'skipped'
          unless File.binary? full_path
            clean_file(full_path)
            result = 'cleaned'
          end
          block.call(full_path, result) if block
        elsif File.directory? full_path and recurse
          clean_dir(full_path, recurse, &block)
        end
      end
    end
  end

end
