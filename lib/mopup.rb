class Mopup

  require 'tempfile'
  require 'fileutils'

  VERSION = '0.0.1'

  attr_reader :options

  def initialize(opts = nil)
    @options = {
      :translate_tabs_to_spaces => false,
      :tab_stop => 2
    }
    @options.merge!(opts) if opts
  end

  def clean(line)
    if @options[:translate_tabs_to_spaces]
      line.gsub!(/\t/, ' ' * @options[:tab_stop]) 
    end
    line.rstrip!
    line
  end

  def clean_text(text)
    buffer = ''
    text.lines do |line|
      clean(line)
      yield(line) if block_given?
      buffer << line
    end
    buffer
  end

  def clean_file(path)
    tmp = Tempfile.new('whitespace-cleaner')
    begin
      File.open(path) do |f|
        while line = f.gets
          clean(line)
          tmp.puts line
        end
      end
      tmp.close
      FileUtils.mv(tmp.path, path)
    ensure
      tmp.close!
    end
  end

  def clean_dir(path, recurse = false, &block)
    Dir.foreach(path) do |entry|
      unless entry =~ /^\./
        full_path = path.chomp('/') + '/' + entry
        if File.file? full_path
          clean_file(full_path)
          block.call(full_path) if block
        elsif File.directory? full_path and recurse
          clean_dir(full_path, recurse, &block)
        end
      end
    end
  end

end
