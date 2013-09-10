#! /bin/sh


./bin/exominer --rdf --name tcga_bc --hugo --doi doi:10.1038/nature11412 --tag 'title=Comprehensive molecular portraits of human breast tumours' --tag 'year=2012;species=human;type=breast cancer' < tcga_bc.txt 
./bin/exominer --rdf --name tcga_bc --hugo --doi doi:10.1038/nature11412 --tag 'title=Comprehensive molecular portraits of human breast tumours' --tag 'year=2012;species=human;type=breast cancer' < tcga_bc.txt > tcga_bc.rdf

curl -T tcga_bc.rdf -H 'Content-Type: application/x-turtle' http://localhost:8081/data/exominer.rdf
