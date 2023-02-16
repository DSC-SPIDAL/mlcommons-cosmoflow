#! /bin/sh

export OMP_NUM_THREADS=1
export KMP_BLOCKTIME=1
export KMP_AFFINITY="granularity=fine,compact,1,0"
export HDF5_USE_FILE_LOCKING=FALSE

echo PROJECT: $PROJECT

set -x
python $PROJECT/hpc/cosmoflow/train.py \
    --config=$PROJECT/configs/rivanna/cosmo-small.yaml \
    --kmp-blocktime=$KMP_BLOCKTIME \
    --kmp-affinity=$KMP_AFFINITY \
    -d $@

# --omp-num-threads=$OMP_NUM_THREADS \
