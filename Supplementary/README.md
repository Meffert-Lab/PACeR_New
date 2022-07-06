# Supplementary Information

| File Name                     | Description |
| ------------ | ------------ |
| create_sncRNA.fasta.sh      | Shell script for manually creating `sncRNA.fasta` file.        |
| sevenmer.txt      | Text file containing all possible 7-mer sequences; used for motif finding.        |
| sixmer.txt      | Text file containing all possible 6-mer sequences; used for motif finding.        |
| sncRNA.fasta      | FASTA file containing miRNA and tRF sequences from mouse.        |
| PACeR.sh      | Shell script for running PACeR.        |
| PACeR_CLEAR-CLIP.sh      | Modified shell script for running PACeR with data from [Moore et al. 2015](https://www.nature.com/articles/ncomms9864).        |
| PeakCalling_Total.sh      | Shell script for calling peaks for all sncRNAs from output of `PACeR.sh`.        |
| PeakCalling_Subset.sh      | Shell script for calling peaks for specific sncRNAs or sncRNA familes from output of `PACeR.sh`.        |

## Installation

Once in the directory where you would like the PACeR files (XX MB) to be installed, run 

    git clone https://github.com/Meffert-Lab/PACeR_New.git

Next, download and configure the larger reference files (XX GB) by running (requires [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html))

    bash /PACeR_New/Installation.sh
