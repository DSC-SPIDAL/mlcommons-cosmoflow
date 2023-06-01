# mlcommons-cosmoflow

Authors:
Gregor von Laszewski, Varun Pavuloori

### Introduction

This readme file will hopefully guide you, in order to setup your environment in Rivanna, download the Cosmoflow data, and help run slurm scripts. 

# Setup the Project Directory

To start, we begin by cloning the contents of the hpc cosmoflow repo and this current mlcommons repo into our system using the following steps:

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

We recommend downloading the data via `globus` using the command line into a new directory titled `data` in your `$PROJECT` directory. The following tutorial steps are directly excerpted from [README-globus.md](https://infomall.org/uva/docs/tutorial/globus/). 
* NOTE: the linked tutorial assumes that the data dir created is in `/project/bii_dsc_community/...` instead of `/scratch/$USER/cosmoflow`

## Globus Set Up on Rivanna

Rivanna allows to load the Globus file transfer command line tools via the modules command with the following commands. However, Prior to executing globus login, please visit <https://www.globus.org/> and log in using your UVA credentials. 

```bash 
module load globus_cli
globus login
```

The `globus login` method will output a unique link per user that you should paste into a web browser and sign in with using your UVA credentials. Afterwords, the website will present you with a unique sign-in key that you will need to paste back into the command line to verify your login. 

After executing `globus login` your console should look like the following block. 

* NOTE: this is a unique link generated for when I attempted to login, each user will have a different link.

```
-bash-4.2$globus login
Please authenticate with Globus here:
------------------------------------
https://auth.globus.org/v2/oauth2/authorize?client_id=affbecb5-5f93-404e-b342-957af296dea0&redirect_uri=https%3A%2F%2Fauth.globus.org%2Fv2%2Fweb%2Fauth-code&scope=openid+profile+email+urn%3Aglobus%3Aauth%3Ascope%3Aauth.globus.org%3Aview_identity_set+urn%3Aglobus%3Aauth%3Ascope%3Atransfer.api.globus.org%3Aall&state=_default&response_type=code&access_type=offline&prompt=login
------------------------------------

Enter the resulting Authorization Code here:
```

Follow the url and input the authorization code to login successfully.

## Source Endpoint Search

First, verify that you were able to sign in properly, and verify your identity and then search for the 
source endpoint of the data you want to transfer. In this example, our endpoint is named `CosmoFlow benchmark data cosmoUniverse_2019_02_4parE`. The following commands will verify your sign in identity and then search for an endpoint within the single quotation marks.

```bash
globus get-identities -v 'youremail@gmailprobably.com'
globus endpoint search 'CosmoFlow benchmark data cosmoUniverse_2019_02_4parE'
```

Each globus endpoint has a unique endpoint ID. In this case our source endpoint ID is:

* `d0b1b73a-efd3-11e9-993f-0a8c187e8c12`

Set up a variable `ENDPOINT` so you can use the endpoint more easily without retyping it. 
Also set a variable `SRC_FILE` to indicate the directory with the files to be transferred.

```bash
export SRC_ENDPOINT=d0b1b73a-efd3-11e9-993f-0a8c187e8c12
export SRC_PATH=/~/
```

You can look at the files in the globus endpoint using `globus ls` to verify that you are looking at the right endpoint.

```bash
globus ls $SRC_ENDPOINT
```

## Destination Endpoint Set Up

Rivanna HPC has set a special endpoint for data transfers into the `/project`, `/home`, or `/scratch` directories. The name of our destination endpoint will be `UVA Standard Security Storage`.

Repeat the above steps with this endpoint and set up the variables including a `path` variable with the desired path to write to.

```bash
globus endpoint search 'UVA Standard Security Storage'
export DEST_ENDPOINT=e6b338df-213b-4d31-b02c-1bc2c628ca07
export DEST_DIR=/dtn/landings/users/u/uj/$USER/project/bii_dsc_community/uja2wd/cosmoflow/
```

* NOTE: to find the specific path of where to write to, it is best to sign into the web format of globus and find your desired path variable. 
    * First sign into the web format of globus
    * Locate `file manager` on the left side of the screen
    * In the `collections` box at the top of the screen begin to search for `UVA Standard Security Storage`
    * Select our destination endpoint
    * Use the GUI tool to select exactly where you wish to write to
    * Copy the path from the box immedietally below `collections`
    * Write this value to the DEST_DIR variable created above (I have included my path to where I wish to write to)

## Initiate the Transfer

Finally, execute the transfer

```bash
globus transfer $SRC_ENDPOINT:$SRC_PATH $DEST_ENDPOINT:$DEST_DIR
```

* NOTE: I anticipate for your first transfer that you will run into an issue where you need to give globus permission to initiate transfers via the CLI instead of via the web tool. I was given the unique command as follows by my terminal:

```bash
-bash-4.2$globus transfer $SRC_ENDPOINT:$SRC_PATH $DEST_ENDPOINT:$DEST_DIR
The collection you are trying to access data on requires you to grant consent for the Globus CLI to access it.
message: Missing required data_access consent

Please run

  globus session consent 'urn:globus:auth:scope:transfer.api.globus.org:all[*https://auth.globus.org/scopes/e6b338df-213b-4d31-b02c-1bc2c628ca07/data_access]'

to login with the required scopes
```

After initiating this command, a similar sign in a verification will be conducted compared to the `globus login` method where the cli will output a url to follow, the user will sign in, and return a verification code.

After fixing this, remember to re-initiate the transfer with the above `globus transfer` command.

## Managing Tasks

To monitor the status of active transfers, use 

```bash
globus task list
```

or similarly you can use the web tool to verify transfers. 


---
* NOTE: In our tests we found that downloading both datasets took 4 hours and 42 minutes. Then, in order to uncompress the `.tar` files, the mini dataset took approximately 15 minutes while the larger dataset took ? hours. Keep this in mind when getting the data.
* NOTE: Also the small dataset is about 6 gb compressed and 12 gb uncompressed whereas the large dataset is 1.6 tb compressed and ? uncompressed.

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

When you cloned the `mlcommons-cosmoflow` there should be a subdirectory called `work` which contains the `cosmoflow.def` file that serves as the build.def file for the image we create in order to run the several scripts inside of `work`

Luckily everything inside the `work` directory is automated via the included makefile so to create an image titled `cosmoflow.sif` we simply need to say: 

```bash rc
make image
```

---

* NOTE: It takes around 5-10 minutes to create an image.
* NOTE: Make sure to exit the special `biihead` node after you are no longer creating images.

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

When submitting a slurm script, it is possible to designate several configurations, usually done so through a `.yaml` file found in `configs`>`rivanna`>`cosmo.yaml` in the mlcommons repository. The `train.py` script will by default designate `cosmo.yaml` as its config, So we have created a `cosmo-large.yaml` and a `cosmo-small.yaml` file that designates the results directory and data directory. To create said results directory execute the following line:

```bash
rivanna> mkdir -p $PROJECT/results
```

scripts can be submitted by navigating to the `work` directory inside of `/scratch/$USER/cosmoflow/mlcommons-cosmoflow/work` and simply running: 

```bash rc
make run
```

The above line will submit `train-gpu.slurm` which runs the large dataset on whichever gpu is most readily available. To run another script specified such as `train-gpu-a100-large.slurm` simply run the following command followed by whatever script you want to run

```bash rc
sbatch train-gpu-a100-large.slurm
```

If all goes well you can do an `ls` to see the contents of the results directory. Usually a file ending with `.err` indicates that something went wrong and opening the file will allow you to read the error message and debug accordingly.

Otherwise, the job should print a results file which you can also open.

To view the status of your job within the `work` directory, the makefile includes `make stat` to display the users current jobs, `make delete` to delete all `.err` and `.out` files in the current directory, and as previously mentioned `make run` to submit the `train-gpu` script.

---
* NOTE: After running train-gpu-small.slurm with 1 node, 8 cores, and 4 gpus on the small dataset, the prg took about 6 hours to complete.

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
rivanna> mkdir -p data
rivanna> cd data

(Globus transfer)
(Un tar datasets)

rivanna> cd $PROJECT/mlcommmons-cosmoflow/work
rivanna> make image
rivanna> sbatch train-gpu-small.slurm
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

Update time to uncompress larger dataset