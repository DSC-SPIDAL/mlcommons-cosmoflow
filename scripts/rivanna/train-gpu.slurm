#!/bin/bash
#SBATCH --time=30:00
#SBATCH --job-name=gpu-v100-train-cosmoflow
#SBATCH --output=%u-%j.out
#SBATCH --error=%u-%j.err
#SBATCH -c 4
#SBATCH --partition=bii-gpu
#SBATCH --account=bii_dsc_community
#SBATCH --mem=32GB
#SBATCH --gres=gpu

hostname
echo "SLURM_CPUS_ON_NODE: $SLURM_CPUS_ON_NODE"
echo "SLURM_CPUS_PER_GPU: $SLURM_CPUS_PER_GPU"
echo "SLURM_GPU_BIND: $SLURM_GPU_BIND"
echo "SLURM_JOB_ACCOUNT: $SLURM_JOB_ACCOUNT"
echo "SLURM_JOB_GPUS: $SLURM_JOB_GPUS"
echo "SLURM_JOB_ID: $SLURM_JOB_ID"
echo "SLURM_JOB_PARTITION: $SLURM_JOB_PARTITION"
echo "SLURM_JOB_RESERVATION: $SLURM_JOB_RESERVATION"
echo "SLURM_SUBMIT_HOST: $SLURM_SUBMIT_HOST"

module purge
module load apptainer
source /scratch/$USER/ENV3

nvidia-smi

export RUN_DIR=/scratch/$USER
export IMAGE=/$RUN_DIR/cosmoflow/mlcommons-cosmoflow/scripts/rivanna/cosmoflow.sif
export SCRIPT_DIR=$RUN_DIR/cosmoflow/hpc
export PROJECT=$RUN_DIR/cosmoflow

#cms gpu system
#cms gpu status
#cms gpu count
#cms gpu watch --gpu=0 --delay=1 --dense > gpu0.log &

cd $RUN_DIR
ls -lisa
ls -lisa $SCRIPT_DIR/cosmoflow/train.py
ls -lisa $PROJECT/mlcommons-cosmoflow/configs/rivanna/cosmo-large.yaml

apptainer exec --nv $IMAGE python $SCRIPT_DIR/cosmoflow/train.py $PROJECT/mlcommons-cosmoflow/configs/rivanna/cosmo-large.yaml




