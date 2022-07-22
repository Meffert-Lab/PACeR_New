#!/bin/sh

while getopts r:m:g: flag
do
    case "${flag}" in
        r) reference_directory=${OPTARG};;
        m) miRBase_species=${OPTARG};;
        g) genome_species=${OPTARG};;
    esac
done

if [ -z "$reference_directory" ]; then
    echo "No reference directory provided"
    exit 1
fi

if [ -z "$miRBase_species" ]; then
    echo "No miRBase species abbreviation provided"
    exit 1
fi

if [ -z "$genome_species" ]; then
    echo "No genome species abbreviation provided"
    exit 1
fi

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	source ${location}/etc/profile.d/conda.sh

	conda activate PACeR

	cd ${reference_directory}

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

#Download miRNA family information

	wget https://www.targetscan.org/vert_71/vert_71_data_download/miR_Family_Info.txt.zip
	unzip miR_Family_Info.txt.zip

#Download genome

	wget http://hgdownload.cse.ucsc.edu/goldenpath/${genome_species}/bigZips/${genome_species}.fa.gz -O ${genome_species}.fa.gz
	gunzip -c ${genome_species}.fa.gz > ${genome_species}.fa
	rm -r ${genome_species}.fa.gz

#Download HISAT2-indexed mouse genome
#Available at http://daehwankimlab.github.io/hisat2/download/

	link=$(awk -v var=${genome_species} '$1 ~ var' ${directory}hisat2_index_downloads.txt | awk '{print $2}')

	wget ${link} -O ${genome_species}.tar.gz
	tar -xf ${genome_species}.tar.gz
	rm -r ${genome_species}.tar.gz

#Download reference genome chromosome sizes

	wget http://hgdownload.cse.ucsc.edu/goldenpath/${genome_species}/bigZips/${genome_species}.chrom.sizes -O ${genome_species}.chrom.sizes

#Download refFlat

	wget https://hgdownload.cse.ucsc.edu/goldenPath/${genome_species}/database/refFlat.txt.gz -O ${genome_species}refFlat.txt

#Index mouse genome for GATK and Samtools

	gatk CreateSequenceDictionary -R ${genome_species}.fa
	samtools faidx ${genome_species}.fa

	conda deactivate