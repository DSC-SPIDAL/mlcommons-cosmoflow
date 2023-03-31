# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori

### Introduction

This readme file will hopefully guide you, in order to setup your environment in Rivanna, download the Cosmoflow data, and help run slurm scripts. 

# Current TODO

Task List:
TODO: Email steve, how to run small for debugging because I cant find documentation
Comp: Globus Transfer
Comp: Adding mini tarball to endpoint

# Setup the Project Directory

To start, we begin by cloning the contents of hpc cosmoflow into our system using the following steps:

```bash
rivanna> export PROJECT=/scratch/$USER/cosmoflow
rivanna> mkdir -p $PROJECT
rivanna> cd $PROJECT
rivanna> git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
rivanna> git clone https://github.com/mlcommons/hpc.git
rivanna> ln -s $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.
```
 
These lines essentially create a Project directory with a soft link to the `hpc` cosmoflow inside `mlcommons-cosmoflow`. When accessing cosmoflow resources in the future make sure to remember to cd to the `$PROJECT` directory.
The above lines will take about 5 mins in total.

# Get the Data

The data for the program is located at 

* <https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/>

We have provided a convenient way to download the data via a Makefile. 

We will download two data sets, a small and a large one. To download both using the aforementioned Makefile we will run a variation of the following command.

```bash
rivanna> time make get-data
```

However, we recommend running this modified command in your project directory.

NOTE: get large data takes a while, we have documented how to only download the small dataset below

```bash
rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-data
```

The download and uncompression of the small dataset will take about 1 minute.
The download and uncompression of the large dataset will take about ?? minutes.

The download of both datasets takes ?? seconds.
The uncompression of that data takes ?? seconds.

---

If you would like to only download the small dataset you can run the following command.

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

---

In case you only like to get the large dataset use

```bash
rivanna> cd $PROJECT
rivanna> time make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-large-data
```

The download of the large data takes about ? seconds to execute on Rivanna.
The uncompress of the large data takes about ? seconds to execute on Rivanna.

---

Once the make file targets are uncompressed you will find the data in the directory 
`$PROJECT/data`, or more specifically `/scratch/$USER/cosmoflow/data`. With the following subdirectories

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
rivanna> export USER_CONTAINER_DIR=/scratch/$USER/.singularity
rivanna> cd $USER_CONTAINER_DIR
rivanna> module load singularity
```

Since the `singularity pull` command will use a lot of resources, make sure to start an interactive job. Some users may be able to succesfully download the `.sif` image without an interactive job, however users of Rivanna will find that the resource restriction requires one.

Start the interactive job using the following command:

```bash
rivanna> ijob -c 1 -p largemem --time=1-00:00:00
```

This will prompt several lines that may look familiar to this: (note that the ##### is in reference to a unique jobid)

```
salloc: Pending job allocation ##### 
salloc: job ##### queued and waiting for resources
salloc: job ##### has been allocated resources
salloc: Granted job allocation #####
```

It should only take a minute or two for the job to start, but once the job has started execute the following line:

```bash
rivanna> singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0
```

The download time will be about 15 minutes.

---
As a side note, if you are using an interactive job, please be sure to exit as soon as the sif image downloads to ensure that you are not charged for unused time. Exiting an interactive job can be as simple as:

```bash
rivanna> exit
```

which should print the following message

```
salloc: Relinquishing job allocation ##### (unique job id)
```

# Writing a Slurm Script

An example Slurm script that runs the `train.py` python script(located in the hpc cosmoflow repository) on the above dataset is located under `scripts`>`rivanna`>`train-small.slurm` or can be found at this hyperlink: [train-cori-rivanna.slurm](https://github.com/DSC-SPIDAL/mlcommons-cosmoflow/blob/main/scripts/rivanna/train-cori-rivanna.slurm)

The slurm script will be referenced below when explaining certain paramaters.

To begin, We will run Cosmoflow benchmark on Rivanna, in the group `bii_dsc_community` and the directory:

```/project/bii_dsc_community```

Furthermore, we will use the slurm partitions depending on which GPU you decide to use:

For a100
  * --partition=bii-gpu
  * --reservation=bi_fox_dgx
  * --account=bii_dsc_community
  * --gres=gpu:a100:1
  * --constraint=a100_80gb

For v100
  * --partition=bii-gpu
  * --account=bii_dsc_community
  * --gres=gpu:v100:1
 
 for running future scripts make sure to use #SBATCH before the above parameters. For example some of the SBATCH parameters for an example job using an a100 would look like:

```bash
#!/bin/bash
#SBATCH --partition=bii-gpu
#SBATCH --reservation=bi_fox_dgx
#SBATCH --account=bii_dsc_community
#SBATCH --constraint=a100_80gb
#SBATCH --mem=32GB
#SBATCH --gres=gpu:a100:1
```

Please note that some important parameters are missing and please consult the example file hyperlinked at the beginning of [Writing A Slurm Script](#writing-a-slurm-script).

Make sure to update the variables in the example script including where your `.sif` image is stored etc. 

# Submitting a Slurm Script

When submitting a slurm script, it is possible to designate several configurations, usually done so through a `.yaml` file found in `configs`>`rivanna`>`cosmo.yaml` in the mlcommons repository. The `train.py` script will by default designate `cosmo.yaml` as its config.

Moving on, in order to submit a slurm script, navigate to the `$PROJECT` directory and then execute the following instructions to create a results subdirectory under `$PROJECT`.

```bash
rivanna> mkdir -p $PROJECT/results
rivanna> cd $PROJECT/results
```

scripts can be submitted by adding them to the `scripts`>`rivanna` folder and calling them via the linux command line. For example to call `train-cori-rivanna.slurm`, from the results sub-directory execute the following command:

```bash
rivanna> sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-cori-rivanna.slurm
rivanna> squeue -u $USER
```

TODO: include a block about what the results are

If all goes well you can do an `ls` to see the contents of the results directory. Usually a file ending with `.err` indicates that something went wrong and opening the file will allow you to read the error message and debug accordingly.

Otherwise, the job should print a results file which you can also open.

# Final Code View

If you are testing for replicability the main steps are to run these lines of code in succession:

```bash
rivanna> export PROJECT=/scratch/$USER/cosmoflow
rivanna> mkdir -p $PROJECT
rivanna> cd $PROJECT
rivanna> git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git  
rivanna> git clone https://github.com/mlcommons/hpc.git
rivanna> ln -s $PROJECT/hpc/cosmoflow $PROJECT/mlcommons-cosmoflow/.

rivanna> cd $PROJECT
rivanna> make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-data

rivanna> mkdir /scratch/$USER/.singularity
rivanna> ln -s /scratch/$USER/.singularity ~/.singularity
rivanna> export USER_CONTAINER_DIR=/scratch/$USER/.singularity
rivanna> cd $USER_CONTAINER_DIR
rivanna> module load singularity
rivanna> ijob -c 1 -p largemem --time=1-00:00:00
rivanna> singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0
rivanna> exit

rivanna> mkdir -p $PROJECT/results
rivanna> cd $PROJECT/results
rivanna> sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-cori-rivanna.slurm
rivanna> squeue -u $USER

```