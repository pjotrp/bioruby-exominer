# bio-exominer

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-exominer.png)](http://travis-ci.org/pjotrp/bioruby-exominer)

Exominer helps build a list of genes that may be used for building a
targeted exome design for sequencing. The inputs are a list of Pubmed
IDs with text files (PDF, HTML, Word, Excel have to be exported to
plain text first). Exominer harvests gene names from these documents
using a default symbol list with aliases. 
Ideally, all texts only contain HUGO symbols, the over 30K standardized
gene names by the HUGO Gene Nomenclature Committee (HGNC). Exominer
does that, but it also mines for the 12 odd million symbols and aliases that
are known through NCBI.

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

Questions to ask from the RDF 

* What genes are mentioned in a paper?
* What papers refer to certain genes?
* What genes are mentioned most in papers?
* What genes are mentioned only in one paper?
* What genes are mentioned since 2011?
* What genes are linked to a certain disease subtype?
* What genes are linked to some author or lab?
* What genes exist in a design?
* What are the genes in a design that are non-HUGO named
* What are the genes in a paper that are non-HUGO named
* How do designs differ?
* What genes are not in a design mentioned since 2010?

When linking out to TCGA and bio2rdf we can get mutation information and gene sizes

* Give mutations of genes and their sizes of those listed in a paper 
* Give mutations of genes and their sizes of those listed in a design

The TCGA (maf) data is provided by Will's publisci RDF. We can ask
patient related questions

* How many patients are in the database?
* How many patients per tumor type?

And mutation related questions

* Rank patients on number of mutations
* How many genes show at least one mutation per patient
* What genes in what patients show more than X mutations (normalized for gene length)
* Rank genes on number of mutations (normalized for gene length)
* List mutated genes per patient
* List patient per mutated gene
* List all mutations that have exactly the same start position and matching variant type (SNP, INS, DEL)

These questions are answered through SPARQL queries below.

Note: this software is under active development!

## Installation

```sh
gem install bio-exominer
```

## Quick start

List all genes in a paper. Visit the paper with your browser and save
it as HTML or text to 'paper.txt'

## Command line interface (CLI)

### Adding NCBI symbols and aliases

NCBI provides a current list of all NCBI used symbols in one large file at

  ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz.

Fetch this file and unpack it. Note: this is a 1.4Gb file; do not
check this file into the repository! Create the symbol/alias list for
exominer with

  ncbi_exominer_symbols gene_info > ncbi_symbols.tab

That makes for some 12 million symbols + aliases(!)

Next to the ncbi_symbols.tab file a frequency file is generated named
ncbi_exominer_symbols.freq, which contains the frequency of every
character used in symbol names:

  p: 1255137
  L: 1907635
  e: 1334974
  u: 465711
  D: 2110781
  n: 533637
  _: 11942258

and a list of all characters

   "#%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]_`abcdefghijklmnopqrstuvwxyz{}

In this list some gene symbols and gene names include dashes and dots
and other characters. Some gene names even contain spaces - we skip
these for further processing.

The millions of NCBI symbols and aliases we do not all write to a
triple-store. We only store those symbols that get mined from the
documents. 

### Adding HUGO symbols and aliases

To make sure all recent HUGO symbols are added, download the all symbols file
and parse it through 

```sh
  wget ftp://ftp.ebi.ac.uk/pub/databases/genenames/reference_genome_set.txt.gz
  gzip -d reference_genome_set.txt.gz
  hugo_exominer_symbols reference_genome_set.txt > hugo_symbols.tab
```

A HUGO file is included with the gem (in test/data/input/hugo_symbols) and will be
loaded if you use the --hugo switch without specifying a symbol file. 

### Making a text file of your document

Save HTML/Word/Excel/PDF files in a textual format. Command line
tools, such as lynx, antiword and pdftotext exist for this purpose. An
example of a textual version of an online Nature paper can be made with

  lynx --dump http://www.nature.com/nature/journal/v490/n7418/full/nature11412.html >> tcga_bc.txt

Warning: do not check this file into the repository! Nature publishing
group will not be amused.

### Using Exominer to mine a text file for symbols

Pass the symbol file on the command line and pipe in the textual file, e.g.

  exominer -s ncbi_symbols.tab --hugo hugo_symbols.tab < tcga_bc.txt 

This results in a list of symbols and aliases found in the paper, with
their tally. For example

    35      FOXA1   forkhead box A1
    36      cas     CRISPR associated Cas2 family protein
    36      AKT1    v-akt murine thymoma viral oncogene homolog 1
    37      BRCA2   hypothetical protein
    37      BRAF    v-raf murine sarcoma viral oncogene homolog B1
    37      BRCA1   breast cancer 1, early onset
    38      A       replication gene A protein
    38      AFF2    Ady2-Fun34 like Family, similar to S. cerevisiae FUN34 (YNR002C) and ADY2 (YCR010C); similar to Yarrowia glyoxalate pathway regulator, possible transmembrane acetate facilitator/sensor
    39      PDGFRA  platelet-derived growth factor receptor, alpha polypeptide
    39      RAD51C  Rad51 DNA recombinase 3
    39      MAP3K1  mitogen-activated protein kinase kinase kinase 1, E3 ubiquitin protein ligase
    41      AKT3    v-akt murine thymoma viral oncogene homolog 3 (protein kinase B, gamma)
    43      ATM     hypothetical protein
    90      can     carbonic anhydrase 2 Can

  Out of a total of 12,774,630 symbols and 3,201,281 aliases scanned(!)

This is not an authorative list but because it is such a comprehensive
list of symbols and aliases there should be few false negatives.
Obviously the last one is a false positive, but these should be easy
to spot and weed out. The idea is to end up with a list of candidate
exome targets. So the possible next step (when not using using a
triple-store) allows for subtracting symbols already in a design (not
yet implemented/NYI):

  exominer -s ncbi_symbols.tab --ignore list.tab < tcga_bc.txt

where list.tab contains a list of symbols to ignore. These symbols
*with* their aliases are skipped in the text mining step. 

This can be useful when mining a paper at a time. The better route,
however, is by adding the exome list and accompanying design to a
triple store for further exploration.

## Speeding up text search

To speed things up you can create a binary version of the symbols
table with

  pack_exominer_symbols ncbi_symbols.tab

and rename that file to

  mv symbols.bin ncbi_symbols.bin

Now use the bin version with exominer's -s switch.

## Using exominer with a triple-store

exominer supports RDF! This means that you can use a triple-store as a
'back-end' and add results of multiple runs incrementally. For every
symbol it is possible to track back the publication and even mine
extra information, such as publication date, journal type, and whether
a symbol exists in one or more stored designs. We can even link
aliases to Hugo symbols and link-out
and fetch gene information, such as the length of the nucleotide
sequence. Welcome to the world of the semantic web!

When parsing a publication or other resource we want to refer the
result set to that. Ideally a DOI is used which can be turned into a
URI through http://crossref.org/, e.g. doi:10.1038/171737a0 becomes 
http://dx.doi.org/10.1038/171737a0 and can be queried, as explained
[here](http://inkdroid.org/journal/2011/04/25/dois-as-linked-data/).

If no URI exists, one can use a URL to a web publication, or even
simply the file name with the year and some tags for describing
the target of the publication, such as species or disease type. 

The DOI describing the file:

  exominer --rdf -s ncbi_symbols.tab --hugo hugo_symbols.tab \
    --doi doi:10.1038/nature11412 < tcga_bc.txt 

allows for mining title and publication date for every
symbol found. To add some meta information you could add semi-colon
separated tags

  exominer --rdf -s ncbi_symbols.tab --hugo hugo_symbols.tab \
    --doi doi:10.1038/nature11412 --tag 'species=human;type=breast cancer' < tcga_bc.txt 

which helps mining data later on. If no doi exists, you may just add
title and year:

  exominer --rdf -s ncbi_symbols.tab --tag 'title=Comprehensive molecular portraits of human breast tumours' \
    --tag 'year=2012;species=human;type=breast cancer' < tcga_bc.txt 

multiple tags are also allowed.

exominer generates RDF which can be added to a triple-store. If you
want to add a design (old or new) simply use something like

  exominer --rdf --hugo hugo_symbols.tab --tag 'design=Targeted exome;year=2013;' < design.txt

These commands create turtle RDF with the --rdf switch. Simply pipe
the output into the triple-store with

  curl -T file.rdf -H 'Content-Type: application/x-turtle' http://localhost:8081/data/exominer.rdf

The URI can be a little more descriptive, e.g.:

  curl -T design2012.rdf -H 'Content-Type: application/x-turtle' http://localhost:8081/data/design2012.rdf

Finally, to support multiple searches and make it easier to
dereference sources you can supply a unique name to each result set
with the --name switch. E.g.

  exominer --rdf --name tcga_bc -s ncbi_symbols.tab --hugo hugo_symbols.tab --doi doi:10.1038/nature11412 --tag 'species=human;type=breast cancer' < tcga_bc.txt 

## Vocabularies

In addition to the standard W3C vocabularies, exominer uses the
[journal archiving and interchange tag set
(JAT)](http://jats.nlm.nih.gov/archiving/) for describing
publications. Another is [Bibliontology](http://bibliontology.com/).
The British Library vocabulary may be
[useful](http://www.bl.uk/bibliographic/datasamples.html) too.

## Using exominer with a triple-store

If you intend to use exominer with a triple-store you need to install
one. In principle you can use bio-rdf with any RDF triple store.
Instructions for installing [4store](http://4store.org/) can be found on
[bioruby-rdf](https://github.com/pjotrp/bioruby-rdf). You can add
a new triple-store with

```sh
4s-backend-setup design
4s-backend design
4s-httpd -p 8081 design
```

and check the webserver is running on http://localhost:8081/status/.
Again, check bioruby-rdf for instructions on installing 4store and
sparql-query and examples.

## Mining gene symbols with SPARQL

### Looking for all database information in the triple-store

```sparql
SELECT * WHERE { ?s ?p ?o } 
```

This can be run with the sparql-query tool

```
sparql-query http://localhost:8081/sparql/ 'SELECT * WHERE { ?s ?p ?o } LIMIT 10'
```



With a non-HUGO geneid information can be fetched with

```sparql
SELECT ?type1, ?label1, count(*)
WHERE {
?s1 ?p1 ?o1 .
?o1 bif:contains "HK1" .
?s1 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?type1 .
?s1 <http://www.w3.org/2000/01/rdf-schema#label> ?label1 .
}
ORDER BY DESC (count(*))
```

will render a list of gene id's. Follow up with, for example,
http://bio2rdf.org/geneid:100036759

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

