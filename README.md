# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori

## Table of contents

1. [Installing Rivanna](#install-on-rivanna)

2. [Running Cosmoflow Benchmark on Rivanna](#running-cosmoflow-benchmark-on-rivanna)

   1. [Setting up the Project Directory and Getting the code](#set-up-a-project-directory-to-get-the-code)
   2. [Data Preparation](#data-preparation)
   3. [Set up Python via Miniforge and Conda](#set-up-python-via-miniforge-and-conca)

## Install on Rivanna

```bash
rivanna>
```

```bash
node>
```

## TODO Tasks

Tasks:
DONE - Create a table of contents in the readme
DONE - Update slurm scripts and test functionality for the srun and singularity run
DONE - GIT global declarations for rivanna (git global config) --name and --email
Time the wget for the large dataset


## Running Cosmoflow Benchmark on Rivanna

To run the Cosmoflow benchmark, you will first need to generate the project directory with the code. We assume you are in the group `bii_dsc_community`. THis allows you access to the directory:

```/project/bii_dsc_community```

As well as the slurm partitions `gpu` and `bii_gpu` needed for running future scripts.

## Set up a Project Directory to get the Code

To get the code follow these steps:

```
mkdir -p /project/bii_dsc_community/$USER/cosmoflow
cd /project/bii_dsc_community/$USER/cosmoflow
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
git clone https://github.com/mlcommons/hpc.git
cp -r hpc/cosmoflow mlcommons-cosmoflow/.
```

We need to copy the content of hpc cosmoflow into our cosmoflow


## Data Preparation

Download the data from <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

Small data file: <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz>
To download this dataset use the linux command: 

```bash
rivanna> mkdir data
rivanna> cd data
rivanna> time wget -bqc https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz
rivanna> time tar -xvf cosmoUniverse_2019_05_4parE_tf_small.tgz
rivanna> cd ..
```

The download command takes about 4 seconds to execute on Rivanna.
The uncompress command takes about 11 seconds to execute on Rivanna.
This will be creating two directories called:

* `cosmoUniverse_2019_05_4parE_tf_small/train` (32 files)
* `cosmoUniverse_2019_05_4parE_tf_small/validation` (32 files)

Together this will take up a total of 1.1 GB of space.

Large data file: <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar>
To download the dataset use the linux command:

```bash
rivanna> time wget -bqc https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar & 
rivanna> time tar -xvf cosmoUniverse_2019_05_4parE_tf_v2.tar
```

The download command takes about ? seconds to execute on Rivanna.
The uncompress command takes about ? seconds to execute on Rivanna.


## Set up Python via Miniforge and Conda

gregors version of this

```
rivanna> module load anaconda
rivanna> conda -V    # 4.9.2
rivanna> anaconda -V # 1.7.2
```

```
rivanna> conda create -n COSMOFLOW python=3.8
rivanna> conda activate COSMOFLOW
```

Possible Slurm Script:

module load anaconda
conda -V    # 4.9.2
anaconda -V # 1.7.2
conda activate COSMOFLOW
pip install -r requirements.txt

DO NOT USE CONDA INIT!!!!!


## THE FOLLOWING IS NOT LOOKED AT YET!!!!!!


## Interacting with Rivanna

Rivanna has two brimary modes so users can interact with it. 

* **Interactive Jobs:** The first one are interactive jobs that allow you to 
  reserve a node on rivanna so it looks like a login node. This interactive mode is
  usefull only during the debug phase and can serve as a convenient way to quickly create 
  batch scripts that are run in the second mode.

*  **Batch Jobs:** The second mode is a batch job that is controlled by a batch script. 
   We will showcase here how to set such scripts up and use them 


## References


1. Instructions for running cosmoflow on Rivanna, <https://github.com/DSC-SPIDAL/mlcommons-cosmoflow>
2. MLcommons repository of cosmoflow, <https://github.com/mlcommons/hpc/tree/main/cosmoflow>
3. Paper on cosmoflow, <TBD>
4. Gregor's Tutorial on how to use Rivanna, <https://github.com/cybertraining-dsc/reu2022/blob/main/project/hpc/rivanna-introduction.md>
5. Gregor's on how to set up a Windows Machine for Research, <https://github.com/cybertraining-dsc/reu2022/blob/main/project/windows-configuration.md>
6. Dataset reference, <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>