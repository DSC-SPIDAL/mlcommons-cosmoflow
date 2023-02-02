# mlcommons-cosmoflow

Authors:
Gregor, Varun


## Install on Rivanna

```bash
rivanna>
```

```bash
node>
```


## Running Cosmoflow benchmark on rivanna

To run the Cosmoflow benchmark, you will first need to generate the project directory with the code. We assume you are in the group `bii_dsc_community`. THis allows you access to the directory 

```/project/bii_dsc_community```

As well as the slurm partitions `gpu` and `bii_gpu`

## Set up a project directory and get the code

To get the code follow these steps:

```
mkdir -p /project/bii_dsc_community/$USER/cosmoflow
cd /project/bii_dsc_community/$USER/cosmoflow
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
git clone https://github.com/mlcommons/hpc.git
cd hpc/cosmoflow
cp -r hpc/cosmoflow mlcommons-cosmoflow/.
```

We need to copy the content of hpc cosmoflow into our cosmoflow


## Data Preparation

Download the data from <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

Small data file: <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz>
To download this dataset use the linux command: 

```bash
rivanna> time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz
rivanna> time tar  -xvf cosmoUniverse_2019_05_4parE_tf_small.tgz
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
rivanna> time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar & 
```

TODO: modify wget to run without progress in the background

This command takes about ? seconds to execute on Rivanna. (run this later and test)

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



### Compile OSMI Models in Interactive Jobs

Once you know hwo to create jobs with a propper batch script you will likely no longer need to use interactive jobs. We keep this documentation for beginners that like to experiement in interactive mode to develop batch scripts.

We noticed that when running interactive jobs on compute node it makes writing to the files system a lot faster.
TODO: This is inprecise as its not discussed which file system ... Also you can just use git to sync

First, obtain an interactive job with 

```
rivanna> ijob -c 1 -A bii_dsc_community -p standard --time=1-00:00:00
```

*note: use --partition=bii-gpu --gres=gpu:v100:n to recieve n v100 GPUs

Next

```
node> cd /project/bii_dsc_community/$USER/osmi/osmi-bench/
```

Now edit requirements.txt to remove the version number from grpcio

```
node> pip install –-user  -r requirements.txt 
```


## How Cosmoflow works

- Get the raw data from the NERSC through the web portal
- Preprocess the data using the prepare.py script
	- could use globus to transfer dataset or available via a web link
- There exists preprocessed data in cosmoUniverse_2019_05_4parE_tf_v2.tar
	- This is the 1.0 prelim dataset
- Another preprocessed dataset
	- v0.7 data
- Submission scripts for the benchmark in scripts mlcommons github, YAML config in configs
	- Examples for the v0.7 dataset that I could use

## References


1. Instructions for running cosmoflow on Rivanna, <https://github.com/DSC-SPIDAL/mlcommons-cosmoflow>
2. MLcommons repository of cosmoflow, <https://github.com/mlcommons/hpc/tree/main/cosmoflow>
3. Paper on cosmoflow, <TBD>
4. Gregor's Tutorial on how to use Rivanna, <get>
5. Gregor's on how to set up a Windows Machine for Research, <get>
6. Dataset reference, <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>