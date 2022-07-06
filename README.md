# PACeR: a bioinformatic pipeline for the analysis of sncRNA-target RNA chimeras

## Installation

Once in the directory where you would like the PACeR files (XX MB) to be installed, run 

`git clone https://github.com/Meffert-Lab/PACeR_New.git`

Next, download and configure the larger reference files (XX GB) by running (requires [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html))

`bash /PACeR_New/Installation.sh`
<br>
<br>
| File Name                     | Description |
| ---------- | ------------- |
| environment.yml   | YML file for creating Conda environment with packages required for running PACeR.        |
| Installation.sh      | Shell script for downloading and configuring reference files.        |
| PACeR.sh      | Shell script for running PACeR.        |
| PACeR_CLEAR-CLIP.sh      | Modified shell script for running PACeR with data from [Moore et al. 2015](https://www.nature.com/articles/ncomms9864).        |
| PeakCalling_Total.sh      | Shell script for calling peaks for all sncRNAs from output of `PACeR.sh`.        |
| PeakCalling_Subset.sh      | Shell script for calling peaks for specific sncRNAs or sncRNA familes from output of `PACeR.sh`.        |

| 2_Reference_File_Configuration.sh      | Script for downloading and configuring the sncRNA reference list and the reference genome.       |
| 3_Pipeline.sh   | Script for processing compressed FASTQ files to generate a BAM file containing uniquely aligned reads annotated with the corresponding sncRNA within the read.        |
| 3\*\_Pipeline_for_CLEAR-CLIP.sh   | Script for processing compressed FASTQ files from a previously published dataset ([Moore et al. 2015](https://www.nature.com/articles/ncomms9864)) to generate a BAM file containing uniquely aligned reads annotated with the corresponding sncRNA within the read.        |
| 4a_Peak_Calling_Total.sh   | Script for calling peaks from BAM files containing uniquely aligned reads annotated with the corresponding sncRNA within the read.        |
| 4b_Peak_Calling_Subset.sh   | Script for calling peaks from BAM files containing uniquely aligned reads annotated with the corresponding sncRNA within the read. Subsets reads by individual sncRNAs or sncRNA families and includes motif enrichment analysis.        |
