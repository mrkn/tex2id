require 'spec_helper'
require 'rbconfig'

RSpec.describe "UseMath support" do
  let(:tex2id_path) do
    File.expand_path("../../exe/tex2id", __FILE__)
  end

  let(:libdir) do
    File.expand_path("../../lib", __FILE__)
  end

  let(:expected_result) do
    File.read(fixture_path("test_converted.md"), mode: "r")
  end

  specify "reading input file from stdin when input filename is '-'" do
    open(fixture_path("test_source.md"), "r") do |input|
      IO.popen(
        [RbConfig.ruby, "-I#{libdir}", tex2id_path, "-"],
        mode: "r+",
      ) do |tex2id_io|
        IO.copy_stream(input, tex2id_io)
        tex2id_io.close_write

        result = tex2id_io.read
        expect(result).to eq(expected_result)
      end
    end
  end
end
