# Text parsing

module BioExominer

  module TextParser 

    MAX_SIZE = 120
    SKIP_TOKENS = %w{ can has Ma van large was polymerase had far a impact was East early 
      face Park ali and team tag ras ac tail at al age ac TA tag small this pure such
      type gene pmc but is ten org we an term not as by lost et out how up per for
      end beta der The Ten Out At No How pdf Ding Jan To cell gov even Jun
      Sun DNA Nat in hit doc bin with set Nov unknown key link to cgi
      and or
    }

    # L3MBTL

    def TextParser::valid_token? token
      return false if token.strip == "" 
      return false if token =~ /^(\d|[,])+$/
      return false if token !~ /[a-zA-Z]/  # at least one word char
      true
    end

    def TextParser::add tokens, word
      return if SKIP_TOKENS.include?(word)
      # return if word.size < 2
      tokens[word] ||= 0 
      tokens[word] += 1
    end

    def TextParser::rm_punctuation w
      return nil if w == nil
      word = w.dup
      if word =~ /^\[\d+\]/
        word = word.sub(/^\[\d+\]/,'')
      end
      word = word.sub(/^\(/,'')
      word = word.sub(/\)$/,'')     
      word = word.sub(/[,:;!]$/,'') # remove punctuation
      word = word.sub(/^[`"']/,'')  # remove starting quotes
      word = word.sub(/[`"']$/,'')  # remove ending quotes
      word
    end

    # Return tokens with count
    def TextParser::tokenize buf
      tokens = {}
      list = buf.split(/[\r\n\s]+/)
      list.each_with_index do | word,idx |
        n1 = p1 = nil
        p1 = rm_punctuation(list[idx-1]) if idx>0
        w1 = rm_punctuation(word)
        n1 = rm_punctuation(list[idx+1]) if idx<list.size
        next if w1.size < 2
        next if p1 =~ /table|dataset|supplement|figure|chapter|section|paragraph/i 
        # Filter out letters+name
        if w1 =~ /^[A-Z]/ and w1.capitalize == w1
          next if n1 and n1.size == 1
          next if p1 and p1.size == 1
          next if n1 and n1.size == 2 and n1 =~ /^[A-Z][A-Z]/
          next if p1 and p1.size == 2 and p1 =~ /^[A-Z][A-Z]/
        end
        if w1.size == 2 and w1 =~ /^[A-Z][A-Z]/
          next if p1 and p1 =~ /^[A-Z]/ and p1.capitalize == p1
          next if n1 and n1 =~ /^[A-Z]/ and n1.capitalize == n1
        end
        # Filter out all lowercase small names
        next if w1.size < 4 and w1 == w1.downcase and w1 !~ /\d/
        # Remove brackets and braces in first and last positions
        add(tokens,w1) if TextParser.valid_token?(word)
        # p [word,w1,TextParser.valid_token?(word)]
        add(tokens,word) if TextParser.valid_token?(word) and word != w1
        # split on dash or underscore
        if word =~ /-|_/
          word.split(/-|_/).each do |w|
            add(tokens,w) if TextParser.valid_token?(w)
          end
        end
      end
      # p tokens
      tokens
    end

    # Return a list of tokens with count and context
    def TextParser::tokenize_with_context buf, context_type = :normal
      tokens_context = {}
      tokens_count = {}
      # Split buf into sentences
      sentences = buf.split(/\.\s+/)
      sentences.each do | sentence1 |
        sentence = sentence1.strip.gsub(/(\r|\n)\s*/,' ') 
        # remove quotes
        sentence = sentence.gsub(/"/,'')
        tokens = tokenize(sentence)
        tokens.each { | token, count |
          # shorten the sentence
          sentence2 = 
            if sentence.size > MAX_SIZE+2
              half_size = MAX_SIZE/2
              pos = sentence.index(token)
              start = (pos-half_size<0 ? 0 : pos-half_size)
              stop  = pos+half_size
              s2 = sentence[start..stop]
              s2.sub(/^\w+\s+/,'').sub(/\s+\w+$/,'')
            else
              sentence
            end
          tokens_count[token] ||= 0
          tokens_count[token] += count
          tokens_context[token] ||= []
          tokens_context[token] << sentence2
        }
      end
      return tokens_count, tokens_context
    end
  end

end
