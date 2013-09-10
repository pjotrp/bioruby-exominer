#! /bin/sh


./bin/exominer --rdf --name tcga_bc --hugo --tag 'title=Comprehensive molecular portraits of human breast tumours' --tag 'year=2012;species=human;type=breast cancer' -s ncbi_symbols.tab < tcga_bc.txt > tcga_bc.rdf

curl -T tcga_bc.rdf -H 'Content-Type: application/x-turtle' http://localhost:8081/data/exominer.rdf

~/opt/bin/sparql-query http://localhost:8081/sparql/ 'SELECT * WHERE { ?s ?p ?o } LIMIT 5'

