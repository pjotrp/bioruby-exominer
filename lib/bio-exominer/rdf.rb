module BioExominer

require 'uri'

  module RDF

    def RDF::valid_uri? uri
      uri =~ /^([!#$&-;=?\[\]_a-z~]|%[0-9a-f]{2})+$/i
    end

    # An identifier is used for the subject and predicate in RDF. This is a case-sensitive
    # (shortened) URI. You can change default behaviour for identifiers using the options 
    # --transform-ids (i.e. in the input side, rather than the output side)
    #
    def RDF::make_identifier(s)
      id = s.strip.gsub(/[^[:print:]]/, '').gsub(/[#)(,]/,"").gsub(/[%]/,"perc").gsub(/(\s|\.|\$|\/|\\)+/,"_")
      # id = URI::escape(id)
      id = id.gsub(/\|/,'_')
      id = id.gsub(/\-/,'_')
      if id != s 
        # logger = Bio::Log::LoggerPlus['bio-table']
        $stderr.print "\nWARNING: Changed identifier <#{s}> to <#{id}>"
      end
      if not RDF::valid_uri?(id)
        raise "Invalid URI after mangling <#{s}> to <#{id}>!"
      end
      valid_id = if id =~ /^\d/
                   'r' + id
                 else
                   id
                 end
      valid_id
    end

  end
end

