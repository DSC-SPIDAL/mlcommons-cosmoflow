# Singularity documentation

## Checkout the Code 

```bash
export PROJECT=/scratch/$USER/cosmoflow
export DATA=/scratch/$USER/cosmoflow/data
export SIF_DIR=/scratch/$USER/cosmoflow
mkdir -p $PROJECT
mkdir -p $DATA
mkdir -p $SIF_DIR
cd $PROJECT
git clone git@github.com:DSC-SPIDAL/mlcommons-cosmoflow.git
git clone https://github.com/mlcommons/hpc.git
cd mlcommons-cosmoflow/
# git pull
cd $PROJECT
make -f mlcommons-cosmoflow/scripts/rivanna/Makefile get-small-data
```

## Checkout the Data

```bash
rivanna> cd ../$DATA
rivanna> make get-data
```

## Pulling the image

To get the sif image you must run the following commands in Rivanna in the $PROJECT directory

```bash
rivanna> mkdir /scratch/$USER/.singularity
rivanna> ln -s /scratch/$USER/.singularity ~/.singularity
rivanna> cd $SIF_DIR
rivanna> module load singularity
```

Some systems may have resource restrictions, Rivanna for example requires a user to start an interactive job in order to run the singularity pull command to get the sif file

Use the following command to start an interactive job in Rivanna:

```bash
rivanna> ijob -c 1 -p largemem --time=1-00:00:00
```

Now, after either starting the job or proceeding from loading the singularity module, execute the singularity pull instruction.

```bash
rivanna> singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0
```

Afterwards, using the following sbatch settings to run a script you can execute scripts for cosmoflow. Take note of the directory in which you store the .sif image as you will need this for your slurm script.

## Slurm Script

An example script will be available in scripts > rivanna > train-cori-rivanna.slurm

