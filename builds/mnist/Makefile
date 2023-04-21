BUILD=myimage.def
IMAGE=myimage.sif

image:
	cp $BUILD build.def
	sudo /opt/singularity/3.7.1/bin/singularity build output_image.sif build.def
	cp output_image.sif $IMAGE
	make -f clean

clean:
	rm -rf build.def output_image.sif