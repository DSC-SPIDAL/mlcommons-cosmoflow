#!/usr/bin/env bash
#SBATCH -J tftest
#SBATCH -o tftest-%A.out
#SBATCH -e tftest-%A.err
#SBATCH -p gpu
#SBATCH --gres=gpu:1
#SBATCH -c 1
#SBATCH -t 00:01:00
#SBATCH -A mygroup

module purge
module load singularity

singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0

containerdir=~
singularity run --nv $containerdir/tensorflow-2.1.0-py37.sif tensorflowtest.py