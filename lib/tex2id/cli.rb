require 'tex2id'
require 'optparse'

class Tex2id::CLI
  def self.run(argv)
    self.new(argv).run
  end

  def initialize(argv)
    @argv = argv
    process_options
  end

  attr_reader :argv, :source_file, :output_file

  def run
    unless source_file
      help($stdout)
      return 1
    end

    converter = Tex2id::Converter.new(source, only_fix_md2inao: @only_fix_md2inao)
    with_output_file_io do |io|
      io.write converter.convert
    end
    0
  end

  def help(io)
    io.puts <<-END_HELP
Usage: #{$0} <source_file> [<output_file>]
    END_HELP
  end

  private

  def process_options
    option_parser.parse!(argv)
    @source_file = argv[0]
    @output_file = argv[1]
  end

  def source
    case source_file
    when "-"
      $stdin.read
    else
      IO.read(source_file, mode: 'r')
    end
  end

  def with_output_file_io
    begin
      io = if output_file
        File.open(output_file, 'w')
      else
        $stdout
      end
      yield io
    ensure
      io.close if output_file
    end
  end

  def option_parser
    OptionParser.new.tap do |opts|
      opts.banner += " <source_file> [<output_file>]"
      opts.version = Tex2id::VERSION
      opts.separator ''
      opts.separator 'Options:'
      opts.on('-f', '--only-fix-md2inao', 'Only fix md2inao affected math') { |v| @only_fix_md2inao = v }
    end
  end
end
