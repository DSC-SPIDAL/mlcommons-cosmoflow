## Globus Install

The following instructions were created in order to show how to use Globus from the command line to initiate file transfers. In the examples below, we are downloading the datasets created by `Cosmoflow` into the `/project/bii_dsc_community/$USER/cosmoflow/data` directory.

To begin, Rivanna includes everything needed for accessing globus via the commandline in the module `globus_cli`. Load this module and sign into globus following the instructions given to the terminal. You will need to paste the link given into your web browser and paste the sign in key it gives you back to the terminal. 

```bash 
module load globus_cli
globus login
```

Afterwards, to verify that you were able to sign in properly, use `globus get-identities` to verify your identity and then search for the source endpoint of the data you want to transfer. In this example, our endpoint is named `CosmoFlow benchmark data cosmoUniverse_2019_02_4parE`.

```bash
globus get-identities -v 'youremail@gmailprobably.com'
globus endpoint search 'CosmoFlow benchmark data cosmoUniverse_2019_02_4parE'
```

The endpoint search will give you the unique ID for the globus endpoint which is: `d0b1b73a-efd3-11e9-993f-0a8c187e8c12`. Set up a variable for the globus endpoint in order to easily call it later as well as a variable for what file to transfer at the moment (This cli method of globus transfer documented below is for one file at a time).

```bash
export srcID=d0b1b73a-efd3-11e9-993f-0a8c187e8c12
export transfer=cosmoUnivers_2019_05-4parE_tf_small.tgz
```

You can look at the files in the globus endpoint using `globus ls` in order to verify that you are looking at the right endpoint.

```bash
globus ls $srcID
```

Now that we have selected our source endpoint, in order to select our destination endpoint in our rivanna system. It is best to read through the official documentation located at: <https://www.rc.virginia.edu/userinfo/globus/>

To summarize this however, our destination endpoint will be located at `UVA Standard Security Storage` and depending on what path you set, the data transfer can be mapped to `/project`, `/home`, or `/scratch`.

Repeat the above steps with this endpoint and set up the variables including a `path` variable with the desired path to write to.

```bash
globus endpoint search 'UVA Standard Security Storage'
export destID=e6b338df-213b-4d31-b02c-1bc2c628ca07
export path=dtn/landings/users/u/uj/uja2wd/project/bii_dsc_community/uja2wd/cosmoflow/
```

* NOTE: I located the path by clicking to my desired location on the Globus web tool which gave me the values preceding `/project`, unique paths will need to be found by following the steps on the official documentation, the link for which is above.

Finally, in order to consent to globus using the cli instead of the gui for transfers, run the following command and sign in again with steps similar to `globus login` using the following command:

```bash
globus session consent 'urn:globus:auth:scope:transfer.api.globus.org:all[*https://auth.globus.org/scopes/e6b338df-213b-4d31-b02c-1bc2c628ca07/data_access]'
```

Finally, execute the transfer

```bash
globus transfer $srcID:$transfer $destID:$path
```

* NOTE: this method of transfer initiates each transfer by one file at a time, to change what file you want to transfer rerun the export variable creation for `$transfer`.

To monitor all active transfers, use `globus task list` in the following method to see the status.

```bash
globus task list
```


References:
1. Globus Data Transfer, Rivanna HPC <https://www.rc.virginia.edu/userinfo/globus/>