#!/bin/sh

#Create an environment variable for the path to the directory where the sample directories are stored

directory="/media/sf_Ubuntu_Sharing_2022/files2/"

#Create an environment variable for the path to the directory where the reference files are stored

reference_directory="/media/sf_Ubuntu_Sharing_2022/PACeR_New/"

#Create an environment variable for directory where the HISAT2-indexed reference genome is stored

reference_genome_abbreviation="mm10"

#Create an environment variable containing a list of all samples
#One sample per line

samples="
CS3
CS7
W8FCS1
W8FCS6
"

#Create an environment variable for the minimum number of reads (combined from all samples) necessary to call a peak

minimum_reads=3

#Create an environment variable for the minimum number of libraries that must contain a read supporting a peak for it to be called

minimum_libraries=2

#Create an environment variable for how far peaks should be extended from their center for motif enrichment analysis
#Total width of peak for motif enrichment analysis will be twice the value of the environment variable

extension=10


#For the most part, code modifications are not required below this line
##############################################################################

#Activate conda environemnt 

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	source ${location}/etc/profile.d/conda.sh

	conda activate PACeR

	name="total"

#Delete and temporary files

	[ -e ${directory}${name}_PeakCalling/combined.rearranged.bed ] && rm ${directory}${name}_PeakCalling/combined.rearranged.bed
	[ -e ${directory}${name}_PeakCalling/PACeR.${name}.peaks.bed ] && rm ${directory}${name}_PeakCalling/PACeR.${name}.peaks.bed
	[ -e ${directory}${name}_PeakCalling/PACeR.peak.bed ] && rm ${directory}${name}_PeakCalling/PACeR.peak.bed

#Make a directory in which the intermediate files generated during peak calling will be stored

	mkdir ${directory}${name}_PeakCalling

for sample in ${samples}
do

	gatk SplitNCigarReads \
	-R ${reference_directory}${reference_genome_abbreviation}.fa \
	-I ${directory}${sample}/${sample}.aligned.unique.bam \
	-O ${directory}${name}_PeakCalling/${sample}.split.bam

	bedtools \
	bamtobed \
	-i ${directory}${name}_PeakCalling/${sample}.split.bam \
	> ${directory}${name}_PeakCalling/${sample}.split.bed


#Rearrange to place sncRNA name next to chromosome number

	sed 's/\./\t/' ${directory}${name}_PeakCalling/${sample}.split.bed | \
	awk '{print $1"."$5"\t"$2"\t"$3"\t""X""\t""X""\t"$7}' \
	> ${directory}${name}_PeakCalling/${sample}.split.rearranged.bed


#Combine bed files

	cat "${directory}${name}_PeakCalling/${sample}.split.rearranged.bed" >> ${directory}${name}_PeakCalling/combined.rearranged.bed

done


#Sort combined bed file for easier processing

	sort -k1,1 -k2,2n ${directory}${name}_PeakCalling/combined.rearranged.bed > ${directory}${name}_PeakCalling/combined.rearranged.sorted.bed


#Create a temporary copy of the combined bed file that will be modified during successive rounds of peak calling

	cp ${directory}${name}_PeakCalling/combined.rearranged.sorted.bed ${directory}${name}_PeakCalling/combined.rearranged.sorted.tmp.bed 


#Perform cycles of peak calling

	[ -e ${directory}${name}_PeakCalling/cycles.txt ] && rm ${directory}${name}_PeakCalling/cycles.txt


x=1
while [[ $x > 0 ]]
do

#Merge overlapping reads

	bedtools \
	merge \
	-i ${directory}${name}_PeakCalling/combined.rearranged.sorted.tmp.bed \
	-s \
	-c 6 \
	-o distinct \
	> ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged

#Determine coverage across overlapping regions
#Remove regions with fewer than minimum read threshold (assigned at beginning of script)
#Remaining regions termed "windows"

	bedtools \
	coverage \
	-a <(awk '{print $1"\t"$2"\t"$3"\t""X""\t""X""\t"$4}' ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged) \
	-b ${directory}${name}_PeakCalling/combined.rearranged.sorted.tmp.bed \
	-s \
	-d | \
	awk -v var=${minimum_reads} '$8 >= var' \
	> ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage

	x=$(wc -l ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage | awk '{print $1}')

#Find start and stop position of maximal coverage within window

	paste \
	<(sort -k1,1 -k2,2n -k8,8nr -k7,7n ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage | awk '!window[$1, $2, $3, $6]++' | cut -f 1-3,6,7) \
	<(sort -k1,1 -k2,2n -k8,8nr -k7,7nr ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage | awk '!window[$1, $2, $3, $6]++' | cut -f 7) | \
	awk '{print $1"\t"($2+$5-1)"\t"($2+$6)"\t""X""\t""X""\t"$4}' \
	> ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage.filtered

	cat ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage.filtered >> ${directory}${name}_PeakCalling/PACeR.peak.bed

#Remove reads that overlap with peak

	bedtools \
	subtract \
	-a ${directory}${name}_PeakCalling/combined.rearranged.sorted.tmp.bed \
	-b ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage.filtered \
	-s \
	-A \
	> ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage.filtered.outside

#Replace temporary bed file with bed file that reads were removed from

	mv ${directory}${name}_PeakCalling/combined.rearranged.sorted.merged.coverage.filtered.outside ${directory}${name}_PeakCalling/combined.rearranged.sorted.tmp.bed

	echo "Cycle complete" >> ${directory}${name}_PeakCalling/cycles.txt

done

#Sort bed file for easier processing

	sort -k1,1 -k2,2n ${directory}${name}_PeakCalling/PACeR.peak.bed > ${directory}${name}_PeakCalling/PACeR.peak.sorted.bed

#Determine coverage for each individual sample

for sample in ${samples}
do

	bedtools \
	coverage \
	-a ${directory}${name}_PeakCalling/PACeR.peak.sorted.bed \
	-b <(sort -k1,1 -k2,2n ${directory}${name}_PeakCalling/${sample}.split.rearranged.bed) \
	-s \
	> ${directory}${name}_PeakCalling/${sample}.split.rearranged.coverage.bed

done

#Combine coverages for each sample into a single file
#Each column represents a sample

	first=$(echo "${samples}" | sed -r '/^\s*$/d' | awk 'NR==1')

	[ -e ${directory}tmp.tmp ] && rm ${directory}tmp.tmp

	cut -f 1-6 ${directory}${name}_PeakCalling/${first}.split.rearranged.coverage.bed > ${directory}tmp.tmp

for sample in ${samples}
do

	cut \
	-f 7 \
	${directory}${name}_PeakCalling/${sample}.split.rearranged.coverage.bed | \
	paste ${directory}tmp.tmp - \
	> ${directory}tmp2.tmp

	mv ${directory}tmp2.tmp ${directory}tmp.tmp

done

	mv ${directory}tmp.tmp ${directory}${name}_PeakCalling/PACeR.peak.sorted.coverage.bed

#Remove peaks supported by fewer than minimum number of libraries (assigned at beginning of script)
#Final peak file has information about parameters at the beginning of the bed file, if this is undesired, place a # infront of the following 3 lines

#	echo "#Minimum reads: $minimum_reads" >> ${directory}PACeR.peaks.bed
#	echo "#Cycles: $cycles" >> ${directory}PACeR.peaks.bed
#	echo "#Minimum libraries: $minimum_libraries" >> ${directory}PACeR.peaks.bed

	awk \
	-v var=${minimum_libraries} \
	-v var2=$((6 + $(echo "$samples" | sed -r '/^\s*$/d' | wc -l) )) \
	'{nz=0; for(i=7;i<=var2;i++) nz+=($i!=0)} nz>=var' \
	${directory}${name}_PeakCalling/PACeR.peak.sorted.coverage.bed \
	>> ${directory}${name}_PeakCalling/PACeR.peaks.bed

	bedtools \
	coverage \
	-a <(awk '!/#/' ${directory}${name}_PeakCalling/PACeR.peaks.bed | awk '{print $1"\t"$2"\t"$3"\t""X""\t""X""\t"$6}' | sort -k1,1 -k2,2n) \
	-b <(awk '{print $1"\t"$2"\t"$3"\t""X""\t""X""\t"$6}' ${directory}${name}_PeakCalling/combined.rearranged.sorted.bed | sort -k1,1 -k2,2n) \
	-s | \
	sed 's/\./\t/' | \
	awk '{print $1"\t"$3"\t"$4"\t"$2"\t"$8"\t"$7}' \
	> ${directory}PACeR.peaks.bed

#Intermediate files are stored in folder called 'PACeR_Peak_Calling' which are deleted after peaks are called. If you would like to keep the intermediate files you can place a # in front of the next line

#	rm -r ${directory}PACeR_Peak_Calling

#Output bed format
#Column1: chromosome
#Column2: start
#Column3: stop
#Column4: sncRNA
#Column5: Number of reads supporting peak (combined from all sample)
#Column6: Strand

	echo "Cycles complete: $(wc -l ${directory}${name}_PeakCalling/cycles.txt | awk '{print $1}')"

conda deactivate