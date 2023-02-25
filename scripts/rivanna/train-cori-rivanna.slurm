#!/bin/bash
#SBATCH --time=30
#SBATCH --job-name=train-cosmoflow
#SBATCH --output=%u-%j.out
#SBATCH --error=%u-%j.err
#SBATCH -c 4
#SBATCH --partition=bii-gpu
#SBATCH --reservation=bi_fox_dgx
#SBATCH --account=bii_dsc_community
#SBATCH --constraint=a100_80gb
#SBATCH --mem=32GB
#SBATCH --gres=gpu:a100:1

module purge
module load singularity

## singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0

export SIF_DIR=/scratch/$USER/cosmoflow
export USER_CONTAINER_DIR=/scratch/$USER/.singularity
cd $SIF_DIR

singularity run --nv $USER_CONTAINER_DIR/cosmoflow-gpu_mlperf-v1.0.sif train.py