#!/bin/bash
## TODO: look into this: SBATCH -C knl
#SBATCH -q debug
#SBATCH -t 30
#SBATCH -J train-cori
#SBATCH -?? bii_gpu
## SBATCH ?? gpu
##TODO: Next line is wrong, 
#SBATCH --image docker:sfarrell/cosmoflow-cpu-mpich:latest
#SBATCH -o logs/%x-%j.out

## module load cgpu tensorflow/2.5.0-gpu ##look into cgpu... also what v of tensorflow

module load singularity tensorflow/2.8.0
singularity run --nv $CONTAINERDIR/tensorflow-2.8.0.sif train.py --config=../configs/cosmo.yaml
##specifies script and the config

##To run singularity or the conda

##module load anaconda
##conda -V    # 4.9.2
##anaconda -V # 1.7.2
##conda create -n COSMOFLOW python=3.8
##conda activate COSMOFLOW

##export OMP_NUM_THREADS=32
##export KMP_BLOCKTIME=1
##export KMP_AFFINITY="granularity=fine,compact,1,0"
##export HDF5_USE_FILE_LOCKING=FALSE
##TODO: how to add the above exports to the singularity run
##make sure to include these lines above^^^

##set -x
##srun -l -u shifter python ../cosmoflow/train.py -d $@
##cd ../cosmoflow; srun -l -u shifter python train.py -d $@
##What does the -d do? look into --config=../configs/cosmo.yaml to specify configs

##TODO: look into my helloworld script and what -u shifter does
##TODO: see if the yaml file can be specified by a parameter 
##TODO: understand teh $@