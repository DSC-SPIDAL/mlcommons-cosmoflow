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

export RUN_DIR=/scratch/$USER
export SCRIPT_DIR=$RUN_DIR/cosmoflow/hpc
export USER_CONTAINER_DIR=$RUN_DIR/.singularity
export PROJECT=$RUN_DIR/cosmoflow
cd $RUN_DIR

singularity exec --nv $RUN_DIR/cosmoflow.sif python $SCRIPT_DIR/cosmoflow/train.py --config $PROJECT/mlcommons-cosmoflow/configs/rivanna/cosmo-large.yaml




