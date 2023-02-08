#!/bin/bash
#SBATCH -q debug
#SBATCH --time=30
#SBATCH --job-name=train-cosmoflow
#SBATCH --output=%u-%j.out
#SBATCH --error=%u-%j.err
#SBATCH -c 4
#SBATCH --partition=bii
#SBATCH --reservation=bi_fox_dgx
#SBATCH --account=bii_dsc_community
#SBATCH --mem=32GB
#SBATCH --gres=gpu:v100:1

module load anaconda
conda -V    # 4.9.2
anaconda -V # 1.7.2
conda create -n COSMOFLOW python=3.8
conda activate COSMOFLOW
pip install -r requirements.txt

export PROJECT=/project/bii_dsc_community/$USER/cosmoflow
export OMP_NUM_THREADS=32
export KMP_BLOCKTIME=1
export KMP_AFFINITY="granularity=fine,compact,1,0"
export HDF5_USE_FILE_LOCKING=FALSE

set -x
srun -l -u python $PROJECT/mlcommons-cosmoflow/cosmoflow/train.py \
    --config=$PROJECT/mlcommons-cosmoflow/configs/rivanna/cosmo.yaml \
    --kmp-blocktime=$KMP_BLOCKTIME \
    --kmp-affinity=$KMP_AFFINITY \
    --omp-num-threads=$OMP_NUM_THREADS \
    -d $@

    ##documentation to set up srun statements so I dont have to keep modifying the train.py file


##What does the -d do? look into --config=../configs/cosmo.yaml to specify configs
## -d could do a couple of things: specify a debug level or specify dependencies, the $@ is every command line argument given to the shell

## -u shifter makes it so the output is unbuffered
## look into shifter - documentation under hpc shifter
