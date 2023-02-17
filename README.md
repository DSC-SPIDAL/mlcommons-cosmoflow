# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori


## WARNING

---

***UNDER NO CIRCUMSTANCES 
say `conda init` even
if conda tells you to do that. 
It will mess up your environment !!!!!!!!!!!!!!!!!!!!!***. 

---

## Gregors notes

---

### Ubuntu

First install Python 3.8

```
sudo snap install cmake --classic
sudo apt update && sudo apt upgrade
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8
sudo apt install python3.8-venv
python3.8 -V
# Python 3.8.16
source ~/TF/bin/activate
```

Next install MPI from source

```
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz
tar -xzvf openmpi-4.0.0.tar.gz
cd openmpi-4.0.0
./configure --prefix=/usr/local --with-cuda
sudo make all install
sudo ldconfig
cd ..
```

Now install  tensorflow, horovod and cosmoflow

```bash
mkdir cosmo
cd cosmo/
export PROJECT=`pwd`
cd $PROJECT
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git
git clone https://github.com/mlcommons/hpc.git
make -f mlcommons-cosmoflow/scripts/ubuntu/Makefile get-small-data
pip install -r $PROJECT/mlcommons-cosmoflow/scripts/ubuntu/requirements.txt 
# HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod
pip install --no-cache-dir horovod
```

Now you have a working environment (hopefully, e.g. not yet tested)

to run the program say

```bash
make -f mlcommons-cosmoflow/scripts/ubuntu/Makefile run-small-data
```

This will give now an error in loading data. it seems the configuration is wrong?

```
2023-02-16 10:07:47,398 INFO Loading data
Traceback (most recent call last):
  File "/home/green/cosmo/hpc/cosmoflow/train.py", line 395, in <module>
    main()
  File "/home/green/cosmo/hpc/cosmoflow/train.py", line 282, in main
    datasets = get_datasets(dist=dist, **data_config)
  File "/home/green/cosmo/hpc/cosmoflow/data/__init__.py", line 39, in get_datasets
    return get_datasets(**data_args)
  File "/home/green/cosmo/hpc/cosmoflow/data/cosmo.py", line 207, in get_datasets
    train_dataset, n_train_steps = construct_dataset(
  File "/home/green/cosmo/hpc/cosmoflow/data/cosmo.py", line 108, in construct_dataset
    assert (0 <= n_files) and (n_files <= len(filenames)), (
AssertionError: Requested 524288 files, 32 available
make: *** [mlcommons-cosmoflow/scripts/ubuntu/Makefile:39: run-small-data] Error 1
```
 



---


### macOS M1

set up prg

```bash
export PROJECT=`pwd`
```

use the above if included in your own dir instead of project

```bash
export PROJECT=/project/bii_dsc_community/$USER/cosmoflow
mkdir -p $PROJECT
cd $PROJECT
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git
git clone https://github.com/mlcommons/hpc.git
cd mlcommons-cosmoflow/
# git pull
cd $PROJECT
make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-small-data
```


```bash
pip install -r $PROJECT/mlcommons-cosmoflow/scripts/rivanna/requirements.txt 
```

macos not yet tested


```
brew install cmake
brew install open-mpi
brew install python@3.8
brew install libuv # for horovod
/opt/homebrew/Cellar/python@3.8/3.8.16/bin/python3.8  -m venv ~/TF
source ~/TF/bin/activate
pip install --upgrade pip
pip install tensorflow-macos
HOROVOD_WITHOUT_MPI=1 HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir horovod
```

check

```
python 
Python 3.8.16 (default, Dec  7 2022, 01:27:54) 
[Clang 14.0.0 (clang-1400.0.29.202)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import tensorflow
>>> tensorflow.__version__
'2.11.0'
```

```bash
time pip install -r $PROJECT/mlcommons-cosmoflow/scripts/macos/requirements.txt
```

```
make -f mlcommons-cosmoflow/scripts/macos/Makefile run-small-data
ERROR

tensorflow.python.framework.errors_impl.NotFoundError: dlopen(/Users/USER/TF/lib/python3.8/site-packages/horovod/tensorflow/mpi_lib.cpython-38-darwin.so, 0x0006): weak-def symbol not found '__ZN3xla14HloInstruction5VisitIPKS0_EEN3tsl6StatusEPNS_17DfsHloVisitorBaseIT_EE'
make: *** [run-small-data] Error 1
```

### Rivanna


Set up the teminal as follows so you can have proper width and also ssh in case we need to use git 
```bash
resize # set terminal width and hight
reset  # make sure you start with fresh window may have to add to .bashrc
eval `ssh-agent`
ssh-add
```


## TODO Tasks


Tasks:

* Main Task: clean up the readme file
  * include a section to uninstall python env
    * (the conda deactivate COSMOFLOW)
  * in the future take the TODO tasks out of the readme so that its super clean for anyone to run it

Time the wget for the large dataset in the data dir in $PROJECT

figure out conda (NEVER USE CONDA INIT!!!!!!!!!!!!!)
  conda create

Some program uses a diff version of numpy: Tensorflow 2.11.0 
requires numpy>=1.20, but you'll have numpy 1.19.2 which is incompatible.

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

The data for this program is located at 

* <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

We provide a convenient way to download the data via the Makefile. 
We download two data sets, a small and a large one. To download both simply 
say 

```bash
rivanna> make get-data
```

However, this may 

```bash
rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-data
```

The download of all data takes ?? seconds./
The uncompression of that data takes ?? seconds.

In case you only like to get the small data set use

```bash
rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-small-data
```

The download command takes about 4 seconds to execute on Rivanna.
The uncompress command takes about 11 seconds to execute on Rivanna.
This will be creating two directories called:

* `cosmoUniverse_2019_05_4parE_tf_small/train` (32 files)
* `cosmoUniverse_2019_05_4parE_tf_small/validation` (32 files)

Together this will take up a total of 1.1 GB of space.


In case you only like to get the large dataset use

```bash
rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-large-data
```

The download of the large data takes about ? seconds to execute on Rivanna.
The uncompress of the large data takes about ? seconds to execute on Rivanna.

Once the make file targets are uncompressed you will find the data in the directory 
`$PROJECT/data`. With the following subdirectories

* small data is in: `TODO`
* large data is in: `TODO`



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
rivanna> time pip install -r $PROJECT/mlcommons-cosmoflow/scripts/rivanna/requirements.txt
```

The pip command will take 2 seconds. 

DO NOT USE CONDA INIT!!!!!


## THE FOLLOWING IS NOT LOOKED AT YET!!!!!!

```bash
rivanna> mkdir -p $PROJECT/results
rivanna> cd $PROJECT/results
rivanna> sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-small.slurm
rivanna> squeue -u $USER
```

The squeue command will give you the jobid and the status of the submitted script.


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
