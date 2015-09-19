require 'spec_helper'

RSpec.describe Tex2id do
  it 'has a version number' do
    expect(Tex2id::VERSION).not_to be nil
  end

  describe '.convert' do
    subject(:result) do
      Tex2id.convert(fixture_path('test_source.md'))
    end

    let(:expected_output) do
      IO.read(fixture_path('test_converted.md'), mode: 'r:UTF-8')
    end

    it 'converts TeX notation into InDesign notation' do
      expect(subject).to eq(expected_output)
    end
  end
end
