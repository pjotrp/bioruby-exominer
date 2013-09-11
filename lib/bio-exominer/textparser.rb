# Text parsing

module BioExominer

  module TextParser 

    SKIP_TOKENS = %w{ can has Ma van large was polymerase had far a impact was }
    def TextParser::valid_token? token
      return false if token == ""
      return false if token =~ /^[\d,.]+$/
      return false if token !~ /[a..zA..Z]+/
      true
    end

    def TextParser::add tokens, word
      return if SKIP_TOKENS.include?(word)
      return if word.size < 2
      tokens[word] = 0 if not tokens[word]
      tokens[word] += 1
    end

    def TextParser::tokenize buf
      tokens = {}
      buf.split(/[\s\/.,:]+/).each do | word |
        # Remove brackets and braces in first and last positions
        if word =~ /^\[\d+\]/
          word = word.sub(/^\[\d+\]/,'')
        end
        word = word.sub(/^\(/,'')
        word = word.sub(/\)$/,'')     
        word = word.sub(/[.,:;]$/,'') # remove punctuation
        word = word.sub(/^[`"']/,'')  # remove starting quotes
        word = word.sub(/[`"']$/,'')  # remove ending quotes
        add(tokens,word) if TextParser.valid_token?(word)
        # split on dash
        if word =~ /-/
          word.split(/-/).each do |w|
            add(tokens,w) if TextParser.valid_token?(w)
          end
        end
      end
      tokens
    end
  end

end
