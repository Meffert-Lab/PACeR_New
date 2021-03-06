# PACeR: a bioinformatic pipeline for the analysis of sncRNA-target RNA chimeras

| File Name &nbsp;                    | Description |
| -------------- | ---------- |
| environment.yml   | YML file for creating Conda environment with packages required for running PACeR.        |
| hisat2_index_downloads.txt | Text file containing links to HISAT2-indexed genomes of several common model organisms. |
| miRBase.fasta      | FASTA file containing miRNAs downloaded from [miRBase](https://www.mirbase.org/) (accessed July 15, 2022).        |
| reference_installation.sh      | Shell script for downloading and configuring reference files.        |
| PACeR.sh      | Shell script for running PACeR.        |
| PACeR_CLEAR-CLIP.sh      | Modified shell script for running PACeR with data from [Moore et al. 2015](https://www.nature.com/articles/ncomms9864).        |
| PeakCalling_Total.sh      | Shell script for calling peaks for all sncRNAs from output of `PACeR.sh`.        |
| PeakCalling_Subset.sh      | Shell script for calling peaks for specific sncRNAs or sncRNA familes from output of `PACeR.sh`.        |

## Installation

Once in the directory where you would like the PACeR files (XX MB) to be installed, run:

    sudo apt install git
    git clone https://github.com/Meffert-Lab/PACeR_New.git

Create the Conda environment by running:

    conda config --append channels conda-forge
    conda env create -f PACeR_New/environment.yml -n PACeR

Reference files for common model organisms can be easily configured using their abbreviations. Model organisms not listed here will require manual indexing of the reference genome (see `hisat2_index.sh` in Supplemental folder).

| Model Organism | miRBase Abbreviation | Genome Abbreviation |
| ---------- | ---------- | ---------- |
| Caenorhabditis elegans (Roundworm) | cel | ce10 |
| Drosophila melanogaster (Fruit fly) | dme | dm6 |
| Homo Sapiens (Human) | hsa | hg19 |
| Mus musculus (Mouse) | mmu | mm10 |
| Rattus norvegicus (Rat) | rno | rn6 |

Download and configure the larger reference files (requires [Miniconda](https://docs.conda.io/en/latest/miniconda.html)). <br><br>
Command line arguments:
- `-r` = path to reference directory
- `-m` = miRBase abbreviation
- `-g` = genome abbreviation

Example shown for mouse:

    bash PACeR_New/reference_installation.sh -r /media/sf_Ubuntu_Sharing_2022/PACeR_New -m mmu -g mm10

## Running PACeR

Ensure data files are in the following configuration

        ????????????PACeR_New
        ???         environment.yml
        ???         hisat2_index_downloads.txt
        ???         reference_installation.sh
        ???         miRBase.fasta
        ???         PACeR.sh
        ???         PACeR_CLEAR-CLIP.sh
        ???         PeakCalling_Total.sh
        ???         PeakCalling_Subset.sh
        ???  
        ????????????files 
             ???       
             ???
             ????????????sample1
             ???       sample1_R1.fastq.gz
             ???       sample1_R2.fastq.gz
             ???
             ????????????sample2
             ???       sample2_R1.fastq.gz
             ???       sample2_R2.fastq.gz
             ???
             ????????????sample3
                     sample3_R1.fastq.gz
                     sample3_R2.fastq.gz

Modify the following parameters of the `PACeR.sh` shell script

    directory="/media/sf_Ubuntu_Sharing_2022/files/"

    reference_directory="/media/sf_Ubuntu_Sharing_2022/PACeR_New/"

    reference_genome_abbreviation="mm10"

    samples="
    CS9
    "

    five_prime_adapter=CTACAGTCCGACGATC
    three_prime_adapter=TGGAATTCTCGGGTGCCAAGG

    five_prime_barcode_length=4
    three_prime_barcode_length=2

    minimum_evalue=.05
    minimum_length=14
    maximum_mismatch=2
    maximum_gap=1
    maximum_gap_if_maximum_mismatch=0

    maximum_sncRNA_start_position=1

    minimum_length_after_sncRNA=15


Execute PACeR by running

    bash PACeR.sh
