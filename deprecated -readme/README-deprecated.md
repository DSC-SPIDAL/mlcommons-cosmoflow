## Table of contents

TODO: complete with a good organizational structure

1. [Setup -WIP-](#gregors-notes-for-setup)
2. [Installing Rivanna](#install-on-rivanna)

   1. [Setting up the Project Directory and Getting the code](#set-up-a-project-directory-to-get-the-code)
   2. [Data Preparation](#data-preparation)
   3. [Set up Python via Miniforge and Conda](#set-up-python-via-miniforge-and-conda)
   4. [Job Info](#interacting-with-rivanna)

3. [Running Scripts](#running-scripts)
4. [References](#references)

## Set up Python via Miniforge and Conda

gregors version of this

```bash
rivanna> module load anaconda
rivanna> conda -V    # 4.9.2
rivanna> anaconda -V # 1.7.2
```

```bash
rivanna> time conda create -n -y COSMOFLOW python=3.8
rivanna> conda activate COSMOFLOW
```

The creation of the COSMOFLOW environment will take about 30 seconds.

```bash
rivanna> module load anaconda
rivanna> conda -V    # 4.9.2
rivanna> anaconda -V # 1.7.2
rivanna> conda activate COSMOFLOW
rivanna> time pip install -r $PROJECT/mlcommons-cosmoflow/scripts/rivanna/requirements.txt
```

The pip command will take 2 seconds. 

As a reminder, DO NOT USE CONDA INIT!!!!!

