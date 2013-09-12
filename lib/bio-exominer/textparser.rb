# Text parsing

module BioExominer

  module TextParser 

    SKIP_TOKENS = %w{ can has Ma van large was polymerase had far a impact was East early 
      face Park ali and team tag ras ac tail at al age ac TA tag small this pure such
      type gene pmc but is ten org we an term not as by lost et out how up per for
      end beta der The Ten Out At No How pdf Ding Jan To cell gov even Jun
      Sun DNA Nat in hit doc bin with set Nov unknown key link to cgi
    }

    # L3MBTL

    def TextParser::valid_token? token
      return false if token.strip == "" 
      return false if token =~ /^(\d|[,.])+$/
      return false if token =~ /\W/  # at least one word char
      true
    end

    def TextParser::add tokens, word
      return if SKIP_TOKENS.include?(word)
      return if word.size < 2
      tokens[word] ||= 0 
      tokens[word] += 1
    end

    def TextParser::tokenize buf
      tokens = {}
      buf.split(/[\r\s\/.,:]+/).each do | word |
        w1 = word
        # Remove brackets and braces in first and last positions
        add(tokens,w1) if TextParser.valid_token?(word)
        if word =~ /^\[\d+\]/
          word = word.sub(/^\[\d+\]/,'')
        end
        word = word.sub(/^\(/,'')
        word = word.sub(/\)$/,'')     
        word = word.sub(/[.,:;]$/,'') # remove punctuation
        word = word.sub(/^[`"']/,'')  # remove starting quotes
        word = word.sub(/[`"']$/,'')  # remove ending quotes
        add(tokens,word) if TextParser.valid_token?(word) and word != w1
        # split on dash or underscore
        if word =~ /-|_/
          word.split(/-|_/).each do |w|
            add(tokens,w) if TextParser.valid_token?(w)
          end
        end
      end
      tokens
    end
  end

end
