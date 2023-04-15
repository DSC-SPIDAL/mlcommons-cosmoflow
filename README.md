# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori

### Introduction

This readme file will hopefully guide you, in order to setup your environment in Rivanna, download the Cosmoflow data, and help run slurm scripts. 

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

---

Conversely, it may be easier to do this transfer via the globus cli, for which the documentation is included on the uva infomall.

---

Once the make file targets are uncompressed you will find the data in the directory 

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

To make the image we will be using a special node provided by Rivanna `biihead1.bii.virginia.edu` which should be accessed only for creating images. 

* To access it remember to use `ssh $USER@biihead1.bii.virginia.edu`

Then while standing in your `/scratch/$USER/` directory make sure to create a copy of the supplied file in the mlcommons-cosmoflow repo that cound be found in `/builds/build.def` into a new file that MUST be named `build.def`.

Then run the following command to create an image titled `output_image.sif`:

```bash rc
rivanna> sudo /opt/singularity/3.7.1/bin/singularity build output_image.sif build.def
```

Make sure to rename the image to something that makes more sense for readability.

```bash rc
rivanna> mv output_image.sif cosmoflow.sif
```

As a side note, make sure to exit the special `biihead` node after you are no longer creating images.

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

rivanna> cd ..
rivanna> cp /scratch/$USER/mlcommons/builds/build.def /scratch/$USER/
rivanna> sudo /opt/singularity/3.7.1/bin/singularity build output_image.sif build.def
rivanna> mv output_image.sif cosmoflow.sif

rivanna> mkdir -p $PROJECT/results
rivanna> cd $PROJECT/results
rivanna> sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-cori-rivanna.slurm
rivanna> squeue -u $USER
```

# Rivanna hardware desc

| Cores/Node | Memory/Node | Specialty Hardware | GPU memory/Device | GPU devices/Node | # of Nodes |
|------------|-------------|--------------------|-------------------|-----------------|------------|
| 40         | 354GB       | -                  | -                 | -               | 1          |
| 20         | 127GB       | -                  | -                 | -               | 115        |
| 28         | 255GB       | -                  | -                 | -               | 25         |
| 40         | 384GB       | -                  | -                 | -               | 347        |
| 40         | 768GB       | -                  | -                 | -               | 35         |
| 16         | 1000GB      | -                  | -                 | -               | 4          |
| 48         | 1500GB      | -                  | -                 | -               | 6          |
| 128        | 1000GB      | GPU: A100          | 40GB              | 8               | 2          |
| 128        | 2000GB      | GPU: A100          | 80GB              | 8               | 11         |
| 28         | 255GB       | GPU: K80           | 11GB              | 8               | 8          |
| 28         | 255GB       | GPU: P100          | 12GB              | 4               | 4          |
| 40         | 383GB       | GPU: RTX2080Ti     | 11GB              | 10              | 2          |
| 64         | 128GB       | GPU: RTX3090       | 24GB              | 4               | 5          |
| 28         | 188GB       | GPU: V100          | 16GB              | 4               | 1          |
| 40         | 384GB       | GPU: V100          | 32GB              | 4               | 12         |
| 36         | 384GB       | GPU: V100          | 32GB              | 4               | 2          |



# Current TODO section

TODO:
mnist in cybertraining to test image before waiting for train.py in cosmoflow
  -test singularity
look


-side task: update this documentation to my current progress and flow.


Build def file
TODO: test using
pip install horovod[tensorflow,keras,pytorch,mxnet,spark]
    -submit ticket to ask about this if it fails


build def for mnist and make sure using gpu and singularity image