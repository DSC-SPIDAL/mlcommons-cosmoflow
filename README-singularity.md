# Singularity documentation

## Pulling the image

To get the sif image you must run the following commands in Rivanna

```
rivanna> mkdir dockerIMG
rivanna> module load singularity
rivanna> singularity pull docker://sfarrell/cosmoflow-gpu:mlperf-v1.0
```

Afterwards, using the following sbatch settings to run a script you can execute scripts for cosmoflow