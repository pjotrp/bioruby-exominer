# bio-exominer

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-exominer.png)](http://travis-ci.org/pjotrp/bioruby-exominer)

Exominer helps build a list of genes that may be used for building a
targeted exome design for sequencing. The inputs are a list of Pubmed
IDs and/or URIs to text files (HTML, Word, Excel should be exported to
plain text first). Exominer harvests gene names from these documents
using a default symbol list with aliases. 

All matches are written with their sources, symbol frequencies,
year, and user provided keywords and impact scores and written out.

Exominer also exports to RDF, so that the gene symbols can be stored
into a triple-store and link out to Bio2rdf resources, for example.
The latter allows harvesting pathways, for example.

The initial symbol list with aliases can be fetched/generated from external
sources, such as NCBI, Biomart and/or Bio2rdf. Some example scripts
are in ./scripts

Note: this software is under active development!

## Installation

```sh
gem install bio-exominer
```

## Usage

```ruby
require 'bio-exominer'
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/pjotrp/bioruby-exominer

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-exominer)

## Copyright

Copyright (c) 2013 Pjotr Prins. See LICENSE.txt for further details.

