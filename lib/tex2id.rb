require "tex2id/version"

module Tex2id
  def self.convert(source_filename)
    source = IO.read(source_filename, mode: 'r:Windows-31J:UTF-8')
    Converter.new(source).convert
  end
end

require "tex2id/converter"
