module BioExominer

  module Symbols

    def Symbols::parse_line(line)
      symbol,aliases,descr = line.split(/\t/)
      aliases = 
        if aliases == 'NA'
          nil
        else
          aliases.split(/\|/)
        end
      return symbol,aliases,descr.strip
    end

    def Symbols::each(fn) 
      File.open(fn).each_line do | line |
        yield parse_line(line)
      end
    end
  end

end
