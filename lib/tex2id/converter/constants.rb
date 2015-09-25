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
    (\')                      # [9] prime
  |
    ([-+](?:\d+(?:\.\d+)?|\\infty)) # [10] numbers
  |
    (.+?)                     # [11] other characters
  ]mx

  MACROS = {
    'dots'  => '<cstyle:数式>...<cstyle:>',
    'cdots' => '<cstyle:数式><22EF><cstyle:>',
    'times' => '<cstyle:数式>×<cstyle:>',
    'quad'  => '<cstyle:数式>　<cstyle:>',
    'qquad' => '<cstyle:数式>　　<cstyle:>',
    'sigma' => '<cstyle:数式><F0BE><cstyle:>',
    'Delta' => '<cstyle:数式><ctk:-250><F0A2><ctk:><cstyle:>',
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
