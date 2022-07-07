# Supplementary Information

| File Name                     | Description |
| ------------ | ------------ |
| create_sncRNA.fasta.sh      | Shell script for manually creating `sncRNA.fasta` file.        |
| hisat2_index_mm10.sh      | Shell script for manually indexing mouse genome for use with HISAT2 alignment.        |


## Installation

Once in the directory where you would like the PACeR files (XX MB) to be installed, run 

    git clone https://github.com/Meffert-Lab/PACeR_New.git

Next, download and configure the larger reference files (XX GB) by running (requires [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html))

    bash /PACeR_New/Installation.sh
