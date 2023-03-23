# Getting the Cosmoflow data via globus commandline 

## Data Directory 

We will showcase how toe transfer the cosmoflow data via globus commandline tools. In our axample we will use the data directory as

```bash
export DATA=/project/bii_dsc_community/$USER/cosmoflow/data
```

## Globus Install on Rivanna

Rivanna allows to load the Globus file transfer command line tools via the modules command with

```bash 
module load globus_cli
globus login
```

This will sign you into globus following the instructions given to the terminal. 

**TODO: unclear sentence: You will need to paste the link that is printed into your web browser and paste the sign in key it gives you back to the terminal.**

Next, verify that you were able to sign in properly, and verify your identity and then search for the 
source endpoint of the data you want to transfer. 
In this example, our endpoint is named `CosmoFlow benchmark data cosmoUniverse_2019_02_4parE`.

```bash
globus get-identities -v 'youremail@gmailprobably.com'
globus endpoint search 'CosmoFlow benchmark data cosmoUniverse_2019_02_4parE'
```

The endpoint search will give you a unique globus endpoint ID. It will be  

* `d0b1b73a-efd3-11e9-993f-0a8c187e8c12`

Set up a variable `ENDPOINT` so you can use the endpoint more easily without retyping it. 
Also  set a variable `TRANSFER` to indicate the filename of the file to be transferred

```bash
export SRC_ENDPOINT=d0b1b73a-efd3-11e9-993f-0a8c187e8c12
export SRC_FILE=cosmoUnivers_2019_05-4parE_tf_small.tgz
```

You can look at the files in the globus endpoint using `globus ls` to verify that you are looking at the right endpoint.

```bash
globus ls $SRC_ENDPOINT
```

To locate the endpoint for the destination on rivanna, we can look it up at 

* <https://www.rc.virginia.edu/userinfo/globus/>

TODO: unclear: 
To summarize this however, our destination endpoint will be located at `UVA Standard Security Storage` and depending on what path you set, the data transfer can be mapped to `/project`, `/home`, or `/scratch`.

Repeat the above steps with this endpoint and set up the variables including a `path` variable with the desired path to write to.

TODO: check teh values

```bash
globus endpoint search 'UVA Standard Security Storage'
export DEST_ENDPOINT=e6b338df-213b-4d31-b02c-1bc2c628ca07
export DEST_DIR=dtn/landings/users/u/uj/$USER/project/bii_dsc_community/uja2wd/cosmoflow/
```

* NOTE: In case you need to change these values, one can locate the `DEST_DIR` in the Globus web tool while clicking on the destination and identify the values preceding `/project`, unique paths will need to be found by **following the steps on the official documentation** *(TODO: thats just saying i do not tell you so this documentation is not useful as you have to anyways look uup the documentation and not read this guide)*, the link for which is above.

Finally, in order to consent to globus using the cli instead of the gui for transfers, run the following command and sign in again with steps similar to `globus login` using the following command:

TODO: WHY is $DEST_ENDPOINT NOT USED?

```bash
globus session consent 'urn:globus:auth:scope:transfer.api.globus.org:all[*https://auth.globus.org/scopes/e6b338df-213b-4d31-b02c-1bc2c628ca07/data_access]'
```

Finally, execute the transfer

```bash
globus transfer $SRC_ENDPOINT:$SRC_FILE $DEST_ENDPOINT:DEST_DIR
```


To monitor the status of active transfers, use 

```bash
globus task list
```


## References:

1. Globus Data Transfer, Rivanna HPC <https://www.rc.virginia.edu/userinfo/globus/>
