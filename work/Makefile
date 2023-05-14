RESULT=$(PROJECT)/result
DATA=/$(PROJECT)/data
PROJECT=/scratch/$(USER)/cosmoflow
#DATA=/scratch/$(USER)/cosmoflow/data

BUILD=cosmoflow.def
IMAGE=cosmoflow.sif


image:
	cp ${BUILD} build.def
	sudo /opt/singularity/3.7.1/bin/singularity build output_image.sif build.def
	cp output_image.sif ${IMAGE}
	make -f Makefile clean


clean:
	rm -rf build.def output_image.sif


delete:
	rm -rf *.err *.out


run:
	sbatch train-gpu.slurm


shell:
	singularity shell ${IMAGE}


info:
	echo "user:" $(USER)
	echo "project:" $(PROJECT)


out:
	cat *.out

err:
	cat *.err



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

stat:
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
