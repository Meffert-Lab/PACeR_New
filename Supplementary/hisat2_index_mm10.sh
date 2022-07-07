#! /bin/sh

#Prior to running script, ensure you are in the PACeR directory with the other files downloaded from GitHub

#Assuming conda has been downloaded and the PACeR environment created

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	source ${location}/etc/profile.d/conda.sh

	conda activate PACeR

#Index mouse genome for HISAT2 alignment
#Takes ~2 hours

	hisat2-build mm10.fa genome

	mkdir mm10

	mv genome.* mm10

	conda deactivate