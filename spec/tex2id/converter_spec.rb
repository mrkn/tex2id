require 'spec_helper'

RSpec.describe Tex2id::Converter do
  describe '#convert' do
    let(:source) do |example|
      example.full_description[/source='((?:\\'|[^'])*)'/, 1].gsub(/\\'/, "'")
    end

    subject(:converter) do
      Tex2id::Converter.new(source)
    end

    let(:converter_output) do
      subject.convert
    end

    def self.it_converts_source_to(expected_output)
      it %Q[converts source to '#{expected_output}'] do
        expect(converter_output).to eq(expected_output)
      end
    end

    context "for source='<SJIS-MAC>\n'" do
      it_converts_source_to("<SJIS-MAC>\n")
    end

    context "for source='<ParaStyle:中見出し>基本\n'" do
      it_converts_source_to("<ParaStyle:中見出し>基本\n")
    end

    context "for source='<ParaStyle:本文>$y$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y_1$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式下付き>1<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y_{12}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式下付き>12<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y^1$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式上付き>1<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y^{12}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式上付き>12<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y_{12}^{3}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式下付き><cr:1><crstr:3>12<cr:><crstr:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$y_{12}^{(3)}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式下付き><cr:1><crstr:(3)>12<cr:><crstr:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\dots$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>...<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\cdots$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式><22EF><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\times$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>×<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\quad$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>　<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\'$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式><2032><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\sigma$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F0BE><clig:><cotfcalt:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\Delta$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F0A2><clig:><cotfcalt:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\varepsilon$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F022><clig:><cotfcalt:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\ell$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F060><clig:><cotfcalt:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\max$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式ローマン>max<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\min$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式ローマン>min<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\mathop{\\mathrm{AND}}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式ローマン>AND<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>関数は $f(u) = z_{j}^{(2)} = f(w_{11} x^1 + w_{21}^{(2)} x_2 + w)$ になります。\n'" do
      it_converts_source_to("<ParaStyle:本文>関数は <cstyle:数式>f(u)<cstyle:> <cstyle:数式>=<cstyle:> <cstyle:数式>z<cstyle:><cstyle:数式下付き><cr:1><crstr:(2)>j<cr:><crstr:><cstyle:> <cstyle:数式>=<cstyle:> <cstyle:数式>f(w<cstyle:><cstyle:数式下付き>11<cstyle:> <cstyle:数式>x<cstyle:><cstyle:数式上付き>1<cstyle:> <cstyle:数式>+<cstyle:> <cstyle:数式>w<cstyle:><cstyle:数式下付き><cr:1><crstr:(2)>21<cr:><crstr:><cstyle:> <cstyle:数式>x<cstyle:><cstyle:数式下付き>2<cstyle:> <cstyle:数式>+<cstyle:> <cstyle:数式>w)<cstyle:> になります。\n")
    end

    context "for source='<ParaStyle:本文>$$y$$\n'" do
      it_converts_source_to(<<-END_RESULT)
<pstyle:半行アキ>
<pstyle:数式><cstyle:数式>y<cstyle:>
      END_RESULT
    end

    context "for source='<ParaStyle:本文>$$ y = f(x) $$\n'" do
      it_converts_source_to(<<-END_RESULT)
<pstyle:半行アキ>
<pstyle:数式><cstyle:数式>y<cstyle:> <cstyle:数式>=<cstyle:> <cstyle:数式>f(x)<cstyle:>
      END_RESULT
    end

    context "for source='<ParaStyle:本文>$-1.5$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>\u{2212}1.5<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$w_{ij}^{(\\ell)}$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>y<cstyle:><cstyle:数式下付き><cr:1><crstr:<F060>><crfuid:BKM-cmmi10><crfs:Regular>12<cr:><crstr:><crfuid:><crfs:><cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\Delta E$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F0A2><clig:><cotfcalt:><cstyle:><cstyle:数式>E<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$E\\'(y)$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式>E<2032>(y)<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\ell{} - 1$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F060><clig:><cotfcalt:><cstyle:> <cstyle:数式>\u{2212}<cstyle:> <cstyle:数式>1<cstyle:>\n")
    end

    context "for source='<ParaStyle:本文>$\\ell\u{2212}1$\n'" do
      it_converts_source_to("<ParaStyle:本文><cstyle:数式イタリック><clig:0><cotfcalt:0><F060><clig:><cotfcalt:><cstyle:><cstyle:数式>\u{2212}1<cstyle:>\n")
    end
  end
end
