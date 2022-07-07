#!/bin/sh

#####FOLLOWING LINE TO BE REMOVED BEFORE PUBLICAITON#####
#	cd /media/sf_Ubuntu_Sharing_2022/

	cd PACeR_New

#	conda env create -f environment.yml -n PACeR

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	source ${location}/etc/profile.d/conda.sh

	conda activate PACeR

#Make BLAST database for guide RNA list

	makeblastdb \
	-in sncRNA.fasta \
	-dbtype nucl

#Download mouse genome

#	wget http://hgdownload.cse.ucsc.edu/goldenpath/mm10/bigZips/mm10.fa.gz -O mm10.fa.gz
#	gunzip -c mm10.fa.gz > mm10.fa
#	rm -r mm10.fa.gz

#Download HISAT2-indexed mouse genome

#	wget https://genome-idx.s3.amazonaws.com/hisat/mm10_genome.tar.gz
#	tar -xf mm10_genome.tar.gz
#	rm mm10_genome.tar.gz

#Download reference genome chromosome sizes

#	wget http://hgdownload.cse.ucsc.edu/goldenpath/mm10/bigZips/mm10.chrom.sizes -O mm10.chrom.sizes

#Index mouse genome for GATK and Samtools

#	gatk CreateSequenceDictionary -R mm10.fa
#	samtools faidx mm10.fa

	conda deactivate