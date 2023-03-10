#!/bin/bash
#SBATCH -C gpu -c 10
#SBATCH --ntasks-per-node 8
#SBATCH --gpus-per-task 1
#SBATCH --exclusive
#SBATCH -t 4:00:00
#SBATCH -J train-cgpu
#SBATCH -o logs/%x-%j.out

module load cgpu tensorflow/2.5.0-gpu
module list
#export HOROVOD_TIMELINE=./timeline.json

# Slurm job variables
env | grep SLURM_JOB

set -x
srun -l -u python train.py -d --rank-gpu $@
