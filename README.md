# bio-exominer

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-exominer.png)](http://travis-ci.org/pjotrp/bioruby-exominer)

Exominer helps build a list of genes that may be used for building a
targeted exome design for sequencing. The inputs are a list of Pubmed
IDs with text files (PDF, HTML, Word, Excel have to be exported to
plain text first). Exominer harvests gene names from these documents
using a default symbol list with aliases. 

All matches are written with their sources, symbol frequencies,
year, and user provided keywords and impact scores and written out.

Exominer also exports to RDF, so that the gene symbols can be stored
into a triple-store and link out to Bio2rdf resources.  The latter
allows harvesting pathways.

Every RDF export contains full information on the origin of symbols.
Over time designs can be compared against each other and a historical
record is maintained. It is a good idea to store the textual versions
of the files too.

The initial symbol list with aliases can be fetched/generated from external
sources, such as NCBI, Biomart and/or Bio2rdf. Some example scripts
are in ./scripts. For a more specific treatment of design and
input/output of exominer, see ./doc/design.md.

Note: this software is under active development!

## Installation

```sh
gem install bio-exominer
```

## The command line interface (CLI)

### Using NCBI symbols

NCBI provides a current list of used symbols in one large file at

  ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz.

Fetch this file and unpack it. Note: this is a 1.4Gb file; do not
check this file into the repository! Create the symbol/alias list for
exominer with

  ncbi_exominer_symbols gene_info > ncbi_symbols.tab

That makes for some 12 million symbols + aliases(!)

Next to the ncbi_symbols.tab file a frequency file is generated named
ncbi_exominer_symbols.freq, which contains

  p: 1255137
  L: 1907635
  e: 1334974
  u: 465711
  D: 2110781
  n: 533637
  _: 11942258

   "#%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]_`abcdefghijklmnopqrstuvwxyz{}

apparently some gene symbols and gene names include dashes and dots
and other characters. Some gene names even contain spaces.

### Making a text file of your document

Save HTML/Word/Excel/PDF files in a textual format. Command line
tools, such as lynx, antiword and pdftotext exist for this purpose. An
example can be made with

  lynx --dump http://www.nature.com/nature/journal/v490/n7418/full/nature11412.html >> tcga_bc.txt

Note: do not check this file into the repository! Nature publishing
group will not be amused.

### Using Exominer

Pass the symbol file on the command line and pipe in the textual file, e.g.

  exominer -s ncbi_symbols.tab < tcga_bc.txt 

## Usage

```ruby
require 'bio-exominer'
```

## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/pjotrp/bioruby-exominer

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-exominer)

## Copyright

Copyright (c) 2013 Pjotr Prins. See LICENSE.txt for further details.

