# PACeR: a bioinformatic pipeline for the analysis of sncRNA-target RNA chimeras

## Installation

Once in the directory where you would like the PACeR files (XX MB) to be installed, run 

`git clone https://github.com/Meffert-Lab/PACeR_New.git`

Next, download and configure the larger reference files (XX GB) by running (requires [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html))

`bash /PACeR_New/Installation.sh`
<br>
<br>
| File Name                     | Description |
| ------------ | ------------ |
| Environment.yml   | YML file for creating Conda environment with packages required for running PACeR.        |
| Installation.sh      | Shell script for downloading and configuring reference files.        |
| PACeR.sh      | Shell script for running PACeR.        |
| PACeR_CLEAR-CLIP.sh      | Modified shell script for running PACeR with data from [Moore et al. 2015](https://www.nature.com/articles/ncomms9864).        |
| PeakCalling_Total.sh      | Shell script for calling peaks for all sncRNAs from output of `PACeR.sh`.        |
| PeakCalling_Subset.sh      | Shell script for calling peaks for specific sncRNAs or sncRNA familes from output of `PACeR.sh`.        |
