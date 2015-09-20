module Tex2id::Converter::Constants
  TOKEN_PATTERN = %r[
    \\mathop\{\\mathrm\{([A-Za-z0-9]+)\}\}
                              # [0] roman mathop
  |
    \\(\w+)(?:\s|\{\})?       # [1] macros
  |
    (\s+)                     # [2] whitespaces
  |
    _(?:
      ([\w\d])                # [3] single character superscript
     |
      \{(
        (?:\\\}|[^\}])+       # [4] multiple characters superscript
      )\}
    )
    (?:
      \^(?:
        \{(
          (?:\\\}|[^\}])+     # [5] multiple characters superscript
        )\}
      |
        ([^{])                # [6] single character superscript
      )
    )?
  |
    \^(?:
      \{(
        (?:\\\}|[^\}])+       # [7] multiple characters superscript
      )\}
    |
      ([^{])                  # [8] single character superscript
    )
  |
    (.+?)                     # [9] other characters
  ]mx

  MACROS = {
    'dots'  => '<cstyle:数式>...<cstyle:>',
    'cdots' => '<cstyle:数式><22EF><cstyle:>',
    'times' => '<cstyle:数式>×<cstyle:>',
    'quad'  => '<cstyle:数式>　<cstyle:>',
    'qquad' => '<cstyle:数式>　　<cstyle:>',
    'sigma' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F0BE><clig:><cotfcalt:><cstyle:>',
    'Delta' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F0A2><clig:><cotfcalt:><cstyle:>',
    'varepsilon' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F022><clig:><cotfcalt:><cstyle:>',
    'ell' => '<cstyle:数式イタリック><clig:0><cotfcalt:0><F060><clig:><cotfcalt:><cstyle:>',
    'max' => '<cstyle:数式ローマン>max<cstyle:>',
    'min' => '<cstyle:数式ローマン>min<cstyle:>',
  }.freeze

  CHAR_MAP = {
    "'"     => '<2032>',
    "-"     => "\u{2212}",
  }.freeze

  CHAR_MAP_PATTERN = /(#{Regexp.union(CHAR_MAP.keys)})/
end
