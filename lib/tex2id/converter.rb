class Tex2id::Converter
  def initialize(source)
    @source = source
  end

  def convert
    pass1 = convert_display_math(@source)
    pass2 = convert_inline_math(pass1)
    pass2
  end

  def convert_display_math(source)
    source.gsub(/\$\$(.*?)\$\$/m) {
      [ "<pstyle:半行アキ>",
        "<pstyle:数式>" + convert_tex_source($1.strip),
      ].join("\n")
    }.gsub(/<ParaStyle:本文>(<pstyle:半行アキ>)/) { $1 }
  end

  def convert_inline_math(source)
    source.gsub(/\$(.*?)\$/m) do
      convert_tex_source($1.strip)
    end
  end

  TOKEN_PATTERN = %r[
    # [0] white spaces
    (\s+)
  |
    # [1] macros
    (
      '
    |
      \\(?:
        c?dots
      | times
      | q?quad
      | sigma
      | Delta
      | varepsilon
      | ell
      | max
      | min
      )
    )
  |
    # [2] roman mathop
    \\mathop\{\\mathrm\{(\w+)\}\}
  |
    # [3] normal chars
    ([a-zA-Z0-9\(\)=+]+)
  |
    # subscript
    _(?:
      ([\w\d])  # [4] single character
     |
      \{(
        (?:\\\}|[^\}])+ # [5] multiple characters
      )\}
    )
    (?:
      # optional superscript
      \^(?:
        ([\w\d])  # [6] single character
      |
        \{(
          (?:\\\}|[^\}])+ # [7] multiple characters
        )\}
      )
    )?
  |
    # [8] superscript
    \^([\w\d])
  |
    # [9] superscript
    \^\{((?:\\\}|[^\}])+)\}
  |
    (.) [10] other character
  ]x

  MACROS = {
    "'"      => '<cstyle:数式><2032><cstyle:>',
    '\dots'  => '<cstyle:数式>...<cstyle:>',
    '\cdots' => '<cstyle:数式><22EF><cstyle:>',
    '\times' => '<cstyle:数式>×<cstyle:>',
    '\quad'  => '<cstyle:数式>　<cstyle:>',
    '\qquad' => '<cstyle:数式>　　<cstyle:>',
    '\sigma' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F0BE><clig:><cotfcalt:><cstyle:>',
    '\Delta' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F0A2><clig:><cotfcalt:><cstyle:>',
    '\varepsilon' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F022><clig:><cotfcalt:><cstyle:>',
    '\ell' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F060><clig:><cotfcalt:><cstyle:>',
    '\max' => '<cstyle:数式ローマン>max<cstyle:>',
    '\min' => '<cstyle:数式ローマン>min<cstyle:>',
  }.freeze

  def convert_tex_source(source)
    source.scan(TOKEN_PATTERN).map { |token|
      if (tok = token[0])
        tok
      elsif (tok = token[1])
        MACROS[tok]
      elsif (tok = token[2])
        "<cstyle:数式ローマン>" + tok + "<cstyle:>"
      elsif (tok = token[3])
        "<cstyle:数式>" + tok + "<cstyle:>"
      elsif (tok = token[4] || token[5])
        if (tok2 = token[6] || token[7])
          "<cstyle:数式下付き><cr:1><crstr:#{tok2}>" + tok + "<cr:><crstr:><cstyle:>"
        else
          "<cstyle:数式下付き>" + tok + "<cstyle:>"
        end
      elsif (tok = token[8] || token[9])
        "<cstyle:数式上付き>" + tok + "<cstyle:>"
      else
        token[10]
      end
    }.join('')
  end
end
