#!/bin/bash
## TODO: look into this: SBATCH -C knl
## this is a constraint flag for "knl" which is for knl nodes
#SBATCH -q debug
#SBATCH -t 30
#SBATCH -J train-conda
#SBATCH -p bii
#SBATCH -c 4

module load singularity tensorflow/2.8.0
singularity run \
    --nv $CONTAINERDIR/tensorflow-2.8.0.sif \
    --env=OMP_NUM_THREADS=32,KMP_BLOCKTIME=1,KMP_AFFINITY="granularity=fine,compact,1,0",HDF5_USE_FILE_LOCKING=FALSE
  train.py \
    --config=../configs/cosmo.yaml 

    