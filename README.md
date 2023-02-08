# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori


## WARNING

---

***UNDER NO CIRCUMSTANCES 
say `conda init` even
if conda tells you to do that.It will mess up your environment !!!!!!!!!!!!!!!!!!!!!***. 

---
## TODO Tasks




Tasks:

Main Task: clean up the readme file
  -include a section to uninstall python env
    -(the conda deactivate COSMOFLOW)
  -in the future take the TODO tasks out of the readme so that its super clean for anyone to run it

Time the wget for the large dataset in the data dir in $PROJECT

figure out conda(NEVER USE CONDA INIT!!!!!!!!!!!!!)
  conda create

some program uses a diff version of numpy: Tensorflow 2.11.0 requires numpy>=1.20, but you'll have numpy 1.19.2 which is incompatible.
Update cosmoflow to tensorflow 2.11.0 from 1.15.2


## Table of contents

TODO: complete with a good organizational structure

1. [Installing Rivanna](#install-on-rivanna)

   1. [Setting up the Project Directory and Getting the code](#set-up-a-project-directory-to-get-the-code)
   2. [Data Preparation](#data-preparation)
   3. [Set up Python via Miniforge and Conda](#set-up-python-via-miniforge-and-conca)


## Install on Rivanna

We will run Cosmoflow benchmark on Rivanna, in the group `bii_dsc_community` and the directory:

```/project/bii_dsc_community```

Furthermore, we will use the slurm partitions:

TODO: fill in the ?? after ticket resolves

 * `gpu` and `bii-gpu` or 
 * `??` and `??`
 
 for running future scripts.

See Gregors e-mail.

### Set up a Project Directory to get the Code

To get the code follow these steps:

```bash
export PROJECT=/project/bii_dsc_community/$USER/cosmoflow
mkdir -p $PROJECT
cd $PROJECT
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
git clone https://github.com/mlcommons/hpc.git
# cp -r $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.
ln -s $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.
```

We need to copy the content of hpc cosmoflow into our cosmoflow


## Data Preparation

Download the data from <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

Small data file: <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz>
To download this dataset use the linux command: 

```bash 
rivanna> mkdir $PROJECT/data
rivanna> cd $PROJECT/data
rivanna> time wget -bqc https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz
rivanna> time tar -xvf cosmoUniverse_2019_05_4parE_tf_small.tgz
rivanna> cd $PROJECT
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

```bash
rivanna> module load anaconda
rivanna> conda -V    # 4.9.2
rivanna> anaconda -V # 1.7.2
```

```bash
rivanna> time conda create -n -y COSMOFLOW python=3.8
rivanna> conda activate COSMOFLOW
```

The creation of the COSMOFLOW environment will take about 30 seconds.

```bash
rivanna> module load anaconda
rivanna> conda -V    # 4.9.2
rivanna> anaconda -V # 1.7.2
rivanna> conda activate COSMOFLOW
rivanna> time pip install -r $PROJECT/mlcommons-cosmoflow/scripts/requirements.txt
```

The pip command will take 2 seconds. 

DO NOT USE CONDA INIT!!!!!


## THE FOLLOWING IS NOT LOOKED AT YET!!!!!!

```bash
rivanna> mkdir -p $PROJECT/results
rivanna> cd $PROJECT/results
rivanna> sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train.slurm
```


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