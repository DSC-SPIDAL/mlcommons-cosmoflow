#
# Targets to fetch the data
#

PROJECT=/project/bii_dsc_community/$(USER)/cosmoflow
RESULT=$(PROJECT)/result
#PROJECT=/scratch/$(USER)/cosmoflow
#DATA=/scratch/$(USER)/cosmoflow/data
#DATA=/home/$(USER)/cosmoflow1/data
DATA=/$(PROJECT)/cosmoflow/data

info:
	echo "user:" $(USER)
	echo "project:" $(PROJECT)

create-data-dir:
	mkdir -p $(DATA)

get-data: get-small-data get-large-data



get-small-data: create-data-dir
	cd $(DATA); \
	time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz
	cd $(DATA); \
	time tar zxvf cosmoUniverse_2019_05_4parE_tf_small.tgz

get-large-data: create-data-dir
	cd $(DATA); \
	time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar
	cd $(DATA); \
	time tar -xvf cosmoUniverse_2019_05_4parE_tf_v2.tar

squeue:
	squeue -u $(USER)

run-small-data:
	cd $(RESULT); rm *.err *.out
	cd $(RESULT); sbatch $(PROJECT)/mlcommons-cosmoflow/scripts/rivanna/train-small.slurm
	echo
	echo "ERROR"
	echo 
	cat $(RESULT)/*.err
	echo
	echo "OUT"
	echo
	cat $(RESULT)/*.out

run-large-data:
	cd $(RESULT); sbatch $(PROJECT)/mlcommons-cosmoflow/scripts/rivanna/train-large.slurm
	echo
	echo "ERROR"
	echo 
	cat $(RESULT)/*.err
	echo
	echo "OUT"
	echo
	cat $(RESULT)/*.out
