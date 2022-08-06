require 'spec_helper'

RSpec.describe Tex2id do
  it 'has a version number' do
    expect(Tex2id::VERSION).not_to be nil
  end

  describe '.convert' do
    context 'The source contains "UseMath: true"' do
      subject(:result) do
        Tex2id.convert(fixture_path('test_source.md'))
      end

      let(:expected_output) do
        IO.read(fixture_path('test_converted.md'), mode: 'r')
      end

      it 'converts TeX notation into InDesign notation' do
        expect(subject).to eq(expected_output)
      end
    end

    context 'The source contains "UseMath: false"' do
      subject(:result) do
        Tex2id.convert(fixture_path('test_source_use_math_false.md'))
      end

      let(:expected_output) do
        IO.read(fixture_path('test_unconverted.md'), mode: 'r')
      end

      it 'does not convert TeX notation into InDesign notation' do
        expect(subject).to eq(expected_output)
      end
    end

    context 'The source does not contain UseMath directive' do
      subject(:result) do
        Tex2id.convert(fixture_path('test_unconverted.md'))
      end

      let(:expected_output) do
        IO.read(fixture_path('test_unconverted.md'), mode: 'r')
      end

      it 'does not convert TeX notation into InDesign notation' do
        expect(subject).to eq(expected_output)
      end
    end
  end
end
