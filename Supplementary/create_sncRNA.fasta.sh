#! /bin/sh

#Assuming PACeR repository was downloaded from Github, change to PACeR directory 

	cd PACeR

#Download miRNAs from miRbase

	wget https://www.mirbase.org/ftp/CURRENT/mature.fa.gz -O miRbase.fasta.gz
	gunzip miRbase.fasta.gz

#This portion is written specifically for obtaining mouse miRNAs
#If working with a different model organism, the grep command can be modified to select the 3-letter abbreviation for that model organism
#"miRNA-" is added to the beginning of each miRNA name to differentiate it from other sncRNA sequences in the reference file
#Final miRNA name format (example): miRNA-mmu-let-7c-5p

	awk '/^>/ {printf "%s%s ", pfx, $0; pfx="\n"; next} {printf "%s", $0} END {print ""}' miRbase.fasta | \
	grep "mmu-" | \
	awk '{print $1"\n"$6}' | \
	sed 's/>/>miRNA-/g' \
	> miRbase.mmu.fasta

#Obtain tRNA fragments (tRFs) from tRFdb (http://genome.bioch.virginia.edu/trfdb/index.php)
##Unfortunately these have to be downloaded manually via a web browser (http://genome.bioch.virginia.edu/trfdb/search.php)
###Download the tRF-1, tRF-3, and tRF-5

#Example
#	Select Organism: Mouse
#	Output format: HTML + Comma Separated Values

#For simplicity, the tRF sequences were accessed July 6, 2022 and uploaded to github and may be downloaded using the following code:

	wget https://raw.githubusercontent.com/Meffert-Lab/PACeR_New/main/Supplementary/mouse_tRF-1.csv -O mouse_tRF-1.csv
	wget https://raw.githubusercontent.com/Meffert-Lab/PACeR_New/main/Supplementary/mouse_tRF-3.csv -O mouse_tRF-3.csv
	wget https://raw.githubusercontent.com/Meffert-Lab/PACeR_New/main/Supplementary/mouse_tRF-5.csv -O mouse_tRF-5.csv

#Deduplicate and convert .csv to fasta

	awk -F ', ' 'NR!=1 {print ">tRF-"$1"_"$9}' mouse_tRF-1.csv | \
	sort | \
	uniq | \
	sed 's/_/\n/' \
	> mouse_tRF-1.fasta

	awk -F ', ' 'NR!=1 {print ">tRF-"$1"_"$9}' mouse_tRF-3.csv | \
	sort | \
	uniq | \
	sed 's/_/\n/' \
	> mouse_tRF-3.fasta

	awk -F ', ' 'NR!=1 {print ">tRF-"$1"_"$9}' mouse_tRF-5.csv | \
	sort | \
	uniq | \
	sed 's/_/\n/' \
	> mouse_tRF-5.fasta

#Combine tRF files into a single file

	cat mouse_tRF-1.fasta mouse_tRF-3.fasta mouse_tRF-5.fasta \
	> tRFdb.mmu.fasta

#Combine miRNA and tRF files into a single file

	cat miRbase.mmu.fasta tRFdb.mmu.fasta > sncRNA.fasta
