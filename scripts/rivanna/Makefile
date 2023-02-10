#
# Targets to fetch the data
#

create-data-dir:
	mkdir -p $PROJECT/data

get-data: get-small-data get-large-data

get-small-data: create-data-dir
	cd $PROJECT/data; \
    time wget -bqc https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz; \
    time tar -xvf cosmoUniverse_2019_05_4parE_tf_small.tgz

get-large-data: create-data-dir
	cd $PROJECT/data; \
	time wget -bqc https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar; \
	time tar -xvf cosmoUniverse_2019_05_4parE_tf_v2.tar

squeue:
	squeue -u $USER

run-small-data:
	cd $PROJECT/results; rm *.err *.out
	cd $PROJECT/results; sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-small.slurm

run-large-data:
	cd $PROJECT/results; sbatch $PROJECT/mlcommons-cosmoflow/scripts/rivanna/train-large.slurm

