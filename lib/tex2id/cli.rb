require 'tex2id'

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

    converter = Tex2id::Converter.new(source)
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
    @source_file = argv[0]
    @output_file = argv[1]
  end

  def source
    IO.read(source_file, mode: 'r:UTF-8')
  end

  def with_output_file_io
    begin
      io = if output_file
        File.open(output_file, 'w:UTF-8')
      else
        $stdout
      end
      yield io
    ensure
      io.close
    end
  end
end
