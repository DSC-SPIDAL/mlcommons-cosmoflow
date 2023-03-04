# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori

### Introduction

This readme file will hopefully guide you, in order to setup your environment in Rivanna, download the Cosmoflow data, and help run slurm scripts. 

# Setup the Project Directory

To start, we begin by cloning the contents of hpc cosmoflow into our system using the following steps:

```bash
export PROJECT=/project/bii_dsc_community/$USER/cosmoflow
mkdir -p $PROJECT
cd $PROJECT
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
git clone https://github.com/mlcommons/hpc.git
# cp -r $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.
ln -s $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.
```

These lines essentially create a Project directory and create a hyperlink to them in order to make it easier to cd to it.

# Get the Data

The data for this program is located at 

* <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

We provide a convenient way to download the data via the Makefile. 
We download two data sets, a small and a large one. To download both simply 
say 

TODO: verify this 

```bash
rivanna> time make get-data
```

However, 
TODO: verify this 

```bash
rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-data
```

The download of all data takes ?? seconds.
The uncompression of that data takes ?? seconds.

In case you only like to get the small data set use

```bash
rivanna> cd $PROJECT
rivanna> time make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-small-data
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
rivanna> time make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-large-data
```

The download of the large data takes about ? seconds to execute on Rivanna.
The uncompress of the large data takes about ? seconds to execute on Rivanna.

Once the make file targets are uncompressed you will find the data in the directory 
`$PROJECT/data`. With the following subdirectories

* small data is in: `cosmoUniverse_2019_05_4parE_tf_small`
* large data is in: `cosmoUniverse_2019_05_4parE_tf`

# Info on Running Scripts

Before you can run scripts it is important to know two possible ways to run a script. There are both Interactive Jobs and Batch Jobs. 

* **Interactive Jobs:** The first are interactive jobs that allow you to 
  reserve a node on rivanna so it looks like a login node. This interactive mode is
  useful mostly during the debug phase and can serve as a convenient way to quickly create 
  batch scripts that are run in the second mode. This is useful for when you need a large amount
  of resources to be allocated to your job. It can be accessed using the following line:

  ```bash
  rivanna> ijob -c 1 -p largemem --time=1-00:00:00
  ```

  In the above command, the parameter next to `-c` indicates the number of cores, `-p` is the partition, 
  and `--time` is the length of allocation.

*  **Batch Jobs:** The second mode is a batch job that is controlled by a batch script. 
   We will showcase here how to set such scripts up and use them, and you can view examples of them 
   by locating `scripts` > `rivanna` > `train-cori-rivanna.slurm` or by using this hyperlink
   TODO: see if this link will work from github doc not from vscode
   [train-cori-rivanna.slurm](./main/mlcommons-cosmoflow/scripts/rivanna/train-cori-rivanna.slurm)

   The sbatch parameters and what they control can be found at this website:

   * <https://www.rc.virginia.edu/userinfo/rivanna/slurm/>


# Prepare the Image for Running Scripts

In order to run scripts on rivanna we need to get a prebuilt image for cosmoflow via a `.sif` file. 

Fortunately one is provided to you and can be downloaded via a singularity pull command, the details for which are below. Before beginning to pull the `.sif` file. Make sure that you have already completed the [Get the Data](#get-the-data) section of this README.

To begin execute the following commands in the $PROJECT directory in Rivanna. (Details for setting up $PROJECT can be found in [Setup the Project Dir](#setup-the-project-directory))

```bash
rivanna> mkdir /scratch/$USER/.singularity
rivanna> ln -s /scratch/$USER/.singularity ~/.singularity
rivanna> cd $SIF_DIR
rivanna> module load singularity
```

Since the `singularity pull` command will use a lot of resources, make sure to start an interactive job. Some users may be able to succesfully download the `.sif` image without an interactive job, however users of Rivanna will find that the resource restriction requires one.

Start the interactive job using the following command:

```bash
rivanna> ijob -c 1 -p largemem --time=1-00:00:00
```

Once the job has started execute the following line:

```bash
rivanna> singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0
```

The download time will be about 10 minutes.

# Writing a Slurm Script