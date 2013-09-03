module BioExominer

  module Symbols

    def Symbols::each(fn) 
      File.open(fn).each_line do | line |
        symbol,aliases,descr = line.split(/\t/)
        aliases = 
          if aliases == 'NA'
            nil
          else
            aliases.split(/\|/)
          end
        yield symbol,aliases,descr.strip
      end
    end
  end

end
