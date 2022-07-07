#!/bin/sh

#Download the appropriate version of miniconda
#Verion of python installed in Ubuntu can be found by running:	python3 --version
#Different versions of Miniconda for Linux can be found here: https://docs.conda.io/en/latest/miniconda.html#linux-installers

	wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh
	bash Miniconda3-py38_4.11.0-Linux-x86_64.sh

#Set path to Miniconda to simplify command-line usage
#Information appears in terminal after running the above command
#Example: #	PATH=$PATH:/home/william/miniconda3/condabin/
#To do so automatically:

	location=$(conda info | awk '/base environment/' | awk '{print $4}')
	PATH=$PATH:${location}/condabin/
