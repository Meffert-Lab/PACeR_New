#!/bin/sh

#####FOLLOWING LINE TO BE REMOVED BEFORE PUBLICAITON#####
cd /media/sf_Ubuntu_Sharing_2022/

#Create an environment variable for the miRBase species abbreviation

miRBase_species="mmu"

#Create an environment variable for the genome species abbreviation

genome_species="mm10"

#Change to the directory where reference files are stored

	cd PACeR_New


#For the most part, code modifications are not required below this line
##############################################################################

#	conda env create -f environment.yml -n PACeR

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	source ${location}/etc/profile.d/conda.sh

	conda activate PACeR

#This portion is written specifically for obtaining mouse miRNAs
#If working with a different model organism, the grep command can be modified to select the 3-letter abbreviation for that model organism
#"miRNA-" is added to the beginning of each miRNA name to differentiate it from other sncRNA sequences in the reference file
#Final miRNA name format (example): miRNA-mmu-let-7c-5p

	awk '/^>/ {printf "%s%s ", pfx, $0; pfx="\n"; next} {printf "%s", $0} END {print ""}' miRBase.fasta | \
	grep "${miRBase_species}-" | \
	awk '{print $1"\n"$6}' | \
	sed 's/>/>miRNA-/g' \
	> miRBase_${miRBase_species}.fasta

#Make BLAST database for miRNA list

	makeblastdb \
	-in miRBase_${miRBase_species}.fasta \
	-dbtype nucl

#Download genome

	wget http://hgdownload.cse.ucsc.edu/goldenpath/${genome_species}/bigZips/${genome_species}.fa.gz -O ${genome_species}.fa.gz
	gunzip -c ${genome_species}.fa.gz > ${genome_species}.fa
	rm -r ${genome_species}.fa.gz

#Index genome

		hisat2-build ${genome_species}.fa ${genome_species}

#Download HISAT2-indexed mouse genome
#Available at http://daehwankimlab.github.io/hisat2/download/

#	wget https://genome-idx.s3.amazonaws.com/hisat/mm10_genome.tar.gz
#	tar -xf mm10_genome.tar.gz
#	rm mm10_genome.tar.gz

#Download reference genome chromosome sizes

	wget http://hgdownload.cse.ucsc.edu/goldenpath/${genome_species}/bigZips/${genome_species}.chrom.sizes -O ${genome_species}.chrom.sizes

#Index mouse genome for GATK and Samtools

	gatk CreateSequenceDictionary -R ${genome_species}.fa
	samtools faidx ${genome_species}.fa

	conda deactivate
