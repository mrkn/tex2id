class Tex2id::Converter
  require 'tex2id/converter/constants'

  include Constants

  def initialize(source, only_fix_md2inao: false)
    @source = source
    @only_fix_md2inao = only_fix_md2inao
    @state_stack = []
    @token_stack = []
  end

  def convert
    pass1 = convert_display_math(@source)
    pass2 = convert_inline_math(pass1)
    pass2
  end

  def convert_display_math(source)
    source.gsub(/\$\$(.*?)\$\$/m) {
      tex_source = fix_md2inao($1.strip)
      next "$$#{tex_source}$$" if @only_fix_md2inao

      if (m = /%filename:\s*(\S+)\s*\z/.match(tex_source))
        "<CharStyle:赤字>画像を挿入：#{m[1]}<CharStyle:>"
      else
        [ "<pstyle:半行アキ>",
          "<pstyle:数式>" + convert_tex_source(tex_source),
        ].join("\n")
      end
    }.gsub(/<ParaStyle:本文>(<pstyle:半行アキ>)/) { $1 }
  end

  def convert_inline_math(source)
    source.each_line.map { |line|
      case line
      when /\A<ParaStyle:リスト>/,
           /\A<ParaStyle:リスト白文字>/
        # do nothing
      else
        inline_commands = []
        line.gsub!(/<CharStyle:(?:コマンド|コード（文字単位）)>[^<]+<CharStyle:>/) do |matched|
          id = inline_commands.length
          inline_commands << matched
          "<tex2id_inline_commands[#{id}]>"
        end
        line.gsub!(/\$(.*?)\$/) do
          tex_source = fix_md2inao($1.strip)
          if @only_fix_md2inao
            "$" + tex_source + "$"
          else
            convert_tex_source(tex_source)
          end
        end
        line.gsub!(/<tex2id_inline_commands\[(\d+)\]>/) do
          inline_commands[$1.to_i]
        end
      end
      line
    }.join('')
  end

  def convert_tex_source(source)
    buf = ""
    result = ""

    source.scan(TOKEN_PATTERN) do |token|
      if buf.length > 0 && token[12].nil?
        result << process_normal_characters(buf)
        buf.clear
      end

      case
      when (tok = token[0])
        result << "<cstyle:数式ローマン>" + tok + "<cstyle:>"
      when (tok = token[1])
        result << process_macros(tok)
      when (tok = token[2])
        result << tok
      when (tok = token[3] || token[4] || token[5])
        tok = process_macros(tok) if token[5]
        if (tok2 = token[6] || token[7])
          result << process_superscript_on_subscript(tok2, tok)
        else
          result << "<cstyle:数式下付き>" + tok + "<cstyle:>"
        end
      when (tok = token[8] || token[9] || token[10])
        result << "<cstyle:数式上付き>" + apply_char_map(tok) + "<cstyle:>"
      when (tok = token[11])
        result << process_number(tok)
      when (tok = token[12])
        buf << tok
      end
    end

    result << process_normal_characters(buf) if buf.length > 0

    result
  end

  def apply_char_map(s)
    s = s.gsub(CHAR_MAP_PATTERN) do |matched|
      CHAR_MAP[matched] || matched
    end
  end

  def process_normal_characters(s)
    s = apply_char_map(s)
    "<cstyle:数式>" + s + "<cstyle:>"
  end

  def process_superscript_on_subscript(superscript, subscript)
    converted_superscript = superscript.dup
    MACROS_IN_SUPERSCRIPT.each do |key, value|
      converted_superscript.gsub!(key, value)
    end
    "<cstyle:数式下付き><cr:1><crstr:#{converted_superscript}>#{subscript}<cr:><crstr:><cstyle:>"
  end

  def process_macros(s)
    MACROS[s] || "\\#{s}"
  end

  def process_number(s)
    # TODO: generalize the following
    s.gsub!(/[-\u{2212}]\\infty/) {|x| "<ctk:-150>\u{2212}<ctk:><F031>" }
    s.gsub!(/\\infty/) {|x| '<F031>' }
    if s[0] == '-' || s[0] == "\u{2212}"
      s[0,1] = "<ctk:-300>\u{2212}<ctk:>"
    end
    "<cstyle:数式>#{s}<cstyle:>"
  end

  def fix_md2inao(source)
    source.dup.tap do |s|
      s.gsub!(/<CharStyle:(?:イタリック(?:（変形斜体）)?)?>/, '_')
      s.gsub!(/(?:<005C>){2}/, '\\')
    end
  end
end
