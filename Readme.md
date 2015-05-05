GA4GH Regions of Interest (FASTA Files)
==========
Regions:
* BRCA1
* BRCA2
* SMA
* KIR
* MHC

Overview
----------
* Quickstart: How to download the FASTA files
* Extract Sequences Yourself: Describes how to independently download the regions of interest 
* About: Meta-information about this project

Quickstart
----------
I created a collection of the FASTA files for the above regions of interest as defined by NCBI Gene and fetched from NCBI Nucleotide (the list of NCBI Gene IDs for each region was compiled by hand).

The FASTA files are in the `FASTA` directory and total ~8 MB. They are named `GeneName-NCBIGeneID`.fa for searching convenience.

    FASTA
	    HLA
		    (28 files)
	    KIR
		    (17 files)
	    SMA-6606.fa
	    BRCA2-675.fa
	    BRCA1-672.fa

**Preview the collection contents**

*  https://workbench.qr1hi.arvadosapi.com/collections/qr1hi-4zz18-7zk4muy5grnaqpv# (login with any google account)
*  https://workbench.qr1hi.arvadosapi.com/collections/download/qr1hi-4zz18-7zk4muy5grnaqpv/4qji0cfumh25dttlwteo6rj2b83z2b8vz1l0rja3uzo82bf3s/ (public)

Besides the FASTA directory, there are two other directories, `NCBIGeneXML` and `GeneRefSeqCoordinates`, which contain the intermediate output used to fetch the FASTA files. In total, the collection size is ~65 MB.

**Download the entire collection contents**

A. if you have access to an Arvados VM
    
    arv get qr1hi-4zz18-7zk4muy5grnaqpv . #note trailing dot!

B. otherwise, they are publicly available

    wget --mirror --no-parent --no-host --cut-dirs=3 https://workbench.qr1hi.arvadosapi.com/collections/download/qr1hi-4zz18-7zk4muy5grnaqpv/4qji0cfumh25dttlwteo6rj2b83z2b8vz1l0rja3uzo82bf3s/


Extract Sequences Yourself
-----------
In short:

    $ git clone <this repository>
    $ sh ./geneID_to_refseq_regions.sh ids.csv


Note that the [Entrez Direct](http://www.ncbi.nlm.nih.gov/books/NBK179288/) tools must be available on your PATH.

This describes the process I used to create these FASTA files.
First, compile a list of GeneIDs for each region. I did this by hand in a google doc and the results are at in this repository: `ids.csv`.

    BRCA1,672
    BRCA2,675
    [...]
    V,352962
		
Note: For the HLA genes, I used the IMGT list of gene names, found at ftp://ftp.ebi.ac.uk/pub/databases/ipd/imgt/hla/fasta/ . For the KIR genes, I used NCBI Gene query to list all the KIR genes. http://www.ncbi.nlm.nih.gov/gene and `"Homo sapiens"[porgn] AND KIR`

Then, modify the `geneID_to_refseq_regions.sh` file to run as many times as there are genes / lines in the ids.csv file.

    $ vi geneID_to_refseq_regions.sh
		    for run in {1..48} #change this!

Then, run the script against the CSV file of genes. Make sure that you have `xsltproc` installed if you do not already, and that `transform.xsl` is in your root directory.

    $ sudo apt-get install xsltproc
    $ sh ./geneID_to_refseq_regions.sh ids.csv

All files will be output to the root directory. Sort by filetype and move into separate folders as you wish.


About
==========
Version
----------
* v0.2 -- (08 Dec 2014)
KIR, HLA gene list compiled. All five regions fetched from NCBI. Credit for `transform.xsl` goes to Pierre Lindenbaum, 06 Dec 2014, https://www.biostars.org/p/122680/#122689 .
* v0.1 -- (02 Dec 2014) 
BRCA1, BRCA2, SMA genes on hg19 and hg38 FASTA files created. 

Notes
----------
* v0.2 -- The previous version can be found at https://gist.github.com/nouyang-curoverse/b17a3820d2ccf36f3e47
* v0.1 -- The python `exactsearch.py` program is documented in the source code at https://gist.github.com/nouyang-curoverse/b17a3820d2ccf36f3e47

License
----------
Public Domain

Author
----------
Nancy Ouyang (nancy@curoverse.com)
