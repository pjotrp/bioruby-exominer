module BioExominer

  require 'msgpack'

  module Symbols
    def Symbols::uri(symbol,hugo)
      if hugo[symbol]
        # http://bio2rdf.org/hugo:RAD51C
        "hgnc:"+symbol
      else
        "ncbigene:"+symbol
      end
    end

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
      is_bin = fn =~ /.bin$/

      if is_bin
        u = MessagePack::Unpacker.new(File.new(fn,'rb'))
        begin
          u.each do |obj|
            # print obj[0],"\t",(obj[1] ? obj[1].join('|') : "NA"),"\t",obj[2],"\n"
            yield obj[0],obj[1],obj[2]
          end
        rescue EOFError
        end
      else
        File.open(fn).each_line do | line |
          yield parse_line(line)
        end
      end
    end
  end

end
