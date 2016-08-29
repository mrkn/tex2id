module Tex2id::Converter::Constants
  TOKEN_PATTERN = %r[
    \\mathop\{\\mathrm\{([A-Za-z0-9]+)\}\}
                              # [0] roman mathop
  |
    \\([a-zA-Z]+)(?:\s|\{\})? # [1] macros
  |
    (\s+)                     # [2] whitespaces
  |
    _(?:
      ([\w\d])                # [3] single character subscript
     |
      \{(
        (?:\\\}|[^\}])+       # [4] multiple characters subscript
      )\}
    |
      \\([a-zA-Z]+)           # [5] single macro superscript
    )
    (?:
      \^(?:
        \{(
          (?:\\\}|[^\}])+     # [6] multiple characters superscript
        )\}
      |
        ([^{])                # [7] single character superscript
      )
    )?
  |
    \^(?:
      \{(
        (?:\\\}|[^\}])+       # [8] multiple characters superscript
      )\}
    |
      ([^{])                  # [9] single character superscript
    )
  |
    (\')                      # [10] prime
  |
    ([-+](?:\d+(?:\.\d+)?|\\infty)) # [11] numbers
  |
    (.+?)                     # [12] other characters
  ]mx

  MACROS = {
    'dots'  => '<cstyle:数式>...<cstyle:>',
    'cdots' => '<cstyle:数式><22EF><cstyle:>',
    'times' => '<cstyle:数式>×<cstyle:>',
    'quad'  => '<cstyle:数式>　<cstyle:>',
    'qquad' => '<cstyle:数式>　　<cstyle:>',
    'alpha' => '<cstyle:数式><03B1><cstyle:>',
    'theta' => '<cstyle:数式><03B8><cstyle:>',
    'sigma' => '<cstyle:数式><F0BE><cstyle:>',
    'Delta' => '<cstyle:数式><ctk:-150><F0A2><ctk:><cstyle:>',
    'Theta' => '<cstyle:数式><F0A3><cstyle:>',
    'varepsilon' => '<cstyle:数式><F022><cstyle:>',
    'ell' => '<cstyle:数式><F060><cstyle:>',
    'infty' => '<cstyle:数式><F031><cstyle:>',
    'max' => '<cstyle:数式ローマン>max<cstyle:>',
    'min' => '<cstyle:数式ローマン>min<cstyle:>',
  }.freeze

  MACROS_IN_SUPERSCRIPT = {
    "\\ell" => "<F060>",
  }.freeze

  CHAR_MAP = {
    "'"     => '<ctk:-300><F030><ctk:>',
    "-"     => "\u{2212}",
  }.freeze

  CHAR_MAP_PATTERN = /(#{Regexp.union(CHAR_MAP.keys)})/
end
