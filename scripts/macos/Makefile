#
# Targets to fetch the data
#

# PROJECT=/project/bii_dsc_community/$(USER)/cosmoflow
DATA=$(PROJECT)/data
RESULT=$(PROJECT)/result


info:
	echo "user:" $(USER)
	echor "project:" $(PROJECT)

create-data-dir:
	mkdir -p $(DATA)

get-data: get-small-data get-large-data


get-small-data: create-data-dir
	cd $(DATA); \
	time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_small.tgz
	cd $(DATA); \
	time tar zxvf cosmoUniverse_2019_05_4parE_tf_small.tgz

get-large-data: create-data-dir
	cd $($DATA); \
	time wget https://portal.nersc.gov/project/dasrepo/cosmoflow-benchmark/cosmoUniverse_2019_05_4parE_tf_v2.tar
	cd $($DATA); \
	time tar -xvf cosmoUniverse_2019_05_4parE_tf_v2.tar

squeue:
	squeue -u $(USER)

run-small-data:
	time pip install -r $(PROJECT)/mlcommons-cosmoflow/scripts/macos/requirements.txt
	mkdir -p $(RESULT)
	cd $(RESULT); rm -f *.err *.out
	cd $(RESULT); sh $(PROJECT)/mlcommons-cosmoflow/scripts/macos/train-small.sh
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
