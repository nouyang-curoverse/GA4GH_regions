#!/bin/bash

# Die on errors
set -e

GENEIDFILE=$1
NUMLINES=$(wc -l $GENEIDFILE | cut -d ' ' -f1)
echo $NUMLINES

#ids=$(cat $GENEIDFILE | tr "\n" ",") #turn newlines into commas

#read in CSV file of GENENAME,GENEID
#e.g.
#BRCA1,672

for run in {1..48} #change "48" to however many genes/lines there are in your CSV of GENENAME,GEENID
do 
	while read l; do
		GENENAME=$(echo $l | cut -d, -f1)
		GENEID=$(echo $l | cut -d, -f2)
		echo genename $GENENAME geneid $GENEID

		#fetch the xml description of this Gene from Entrez Direct, unless exists already
		if [ ! -f ./$GENEID.xml ]; then
			epost -db gene -id $GENEID | efetch -format xml > $GENEID.xml
			echo fetched xml for $GENEID
		fi

		#delete everything except the relevant seqid, seqstart, seqend info
		#Results in lines such as:
		#(Reference GRCh38 Primary Assembly)NC_000017:43044294-43125482
		if [ ! -f ./$GENEID-refseqs.xml ]; then
			xsltproc --novalid transform.xsl $GENEID.xml > $GENEID-refseqs.xml
			echo extracted relevant info to $GENEID-refseqs.xml
		fi

		#for each refseq, fetch the FASTA and append it to a single file for this gene
		if [ ! -f ./$GENENAME-$GENEID.fa ]; then
			while read p; do
				SEQID=$(echo $p | cut -d\) -f2 | cut -d: -f1)
				SEQSTART=$(echo $p | cut -d: -f2 | cut -d\- -f1)
				SEQEND=$(echo $p | cut -d\- -f2)
				echo seqid $SEQID seqstart $SEQSTART seqend $SEQEND

				efetch -db nuccore -id $SEQID -seq_start $SEQSTART -seq_stop $SEQEND -format FASTA >> $GENENAME-$GENEID.fa
				echo fetched FASTA file and added it to $GENENAME-$GENEID.fa
			done < $GENEID-refseqs.xml 
		fi

	done < $GENEIDFILE
done
