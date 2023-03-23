# Getting the Cosmoflow data via globus commandline 

## Data Directory 

We will showcase how to transfer the cosmoflow data via globus commandline tools. In our axample we will use the data directory as

```bash
export DATA=/project/bii_dsc_community/$USER/cosmoflow/data
```

## Globus Set Up on Rivanna

Rivanna allows to load the Globus file transfer command line tools via the modules command with the following commands. However, Prior to executing globus login, please visit <https://www.globus.org/> and log in using your UVA credentials. 

```bash 
module load globus_cli
globus login
```

The `globus login` method will output a unique link per user that you should paste into a web browser and sign in with using your UVA credentials. Afterwords, the website will present you with a unique sign-in key that you will need to paste back into the command line to verify your login. 

After executing `globus login` your console should look like the following block. 

* NOTE: this is a unique link generated for when I attempted to login, each user will have a different link.

```bash
-bash-4.2$globus login
Please authenticate with Globus here:
------------------------------------
https://auth.globus.org/v2/oauth2/authorize?client_id=affbecb5-5f93-404e-b342-957af296dea0&redirect_uri=https%3A%2F%2Fauth.globus.org%2Fv2%2Fweb%2Fauth-code&scope=openid+profile+email+urn%3Aglobus%3Aauth%3Ascope%3Aauth.globus.org%3Aview_identity_set+urn%3Aglobus%3Aauth%3Ascope%3Atransfer.api.globus.org%3Aall&state=_default&response_type=code&access_type=offline&prompt=login
------------------------------------

Enter the resulting Authorization Code here:
```

Follow the url and input the authorization code to login successfully.

## Source Endpoint Search

First, verify that you were able to sign in properly, and verify your identity and then search for the 
source endpoint of the data you want to transfer. In this example, our endpoint is named `CosmoFlow benchmark data cosmoUniverse_2019_02_4parE`. The following commands will verify your sign in identity and then search for an endpoint within the single quotation marks.

```bash
globus get-identities -v 'youremail@gmailprobably.com'
globus endpoint search 'CosmoFlow benchmark data cosmoUniverse_2019_02_4parE'
```

Each globus endpoint has a unique endpoint ID. In this case our source endpoint ID is:

* `d0b1b73a-efd3-11e9-993f-0a8c187e8c12`

Set up a variable `ENDPOINT` so you can use the endpoint more easily without retyping it. 
Also  set a variable `SRC_FILE` to indicate the filename of the file to be transferred.

```bash
export SRC_ENDPOINT=d0b1b73a-efd3-11e9-993f-0a8c187e8c12
export SRC_FILE=cosmoUnivers_2019_05-4parE_tf_small.tgz
```

You can look at the files in the globus endpoint using `globus ls` to verify that you are looking at the right endpoint.

```bash
globus ls $SRC_ENDPOINT
```

## Destination Endpoint Set Up

Rivanna HPC has set a special endpoint for data transfers into the `/project`, `/home`, or `/scratch` directories. The name of our destination endpoint will be `UVA Standard Security Storage`.

Repeat the above steps with this endpoint and set up the variables including a `path` variable with the desired path to write to.

```bash
globus endpoint search 'UVA Standard Security Storage'
export DEST_ENDPOINT=e6b338df-213b-4d31-b02c-1bc2c628ca07
export DEST_DIR=dtn/landings/users/u/uj/$USER/project/bii_dsc_community/uja2wd/cosmoflow/
```

* NOTE: to find the specific path of where to write to, it is best to sign into the web format of globus and find your desired path variable. 
    * First sign into the web format of globus
    * Locate `file manager` on the left side of the screen
    * In the `collections` box at the top of the screen begin to search for `UVA Standard Security Storage`
    * Select our destination endpoint
    * Use the GUI tool to select exactly where you wish to write to
    * Copy the path from the box immedietally below `collections`
    * Write this value to the DEST_DIR variable created above (I have included my path to where I wish to write to)

## Initiate the Transfer

Finally, execute the transfer

```bash
globus transfer $SRC_ENDPOINT:$SRC_FILE $DEST_ENDPOINT:$DEST_DIR
```

* NOTE: I anticipate for your first transfer that you will run into an issue where you need to give globus permission to initiate transfers via the CLI instead of via the web tool. I was given the unique command as follows by my terminal:

```bash
-bash-4.2$globus transfer $SRC_ENDPOINT:$SRC_FILE $DEST_ENDPOINT:$DEST_DIR
The collection you are trying to access data on requires you to grant consent for the Globus CLI to access it.
message: Missing required data_access consent

Please run

  globus session consent 'urn:globus:auth:scope:transfer.api.globus.org:all[*https://auth.globus.org/scopes/e6b338df-213b-4d31-b02c-1bc2c628ca07/data_access]'

to login with the required scopes

```

After initiating this command, a similar sign in a verification will be conducted compared to the `globus login` method where the cli will output a url to follow, the user will sign in, and return a verification code.

After fixing this, remember to re-initiate the transfer with the above `globus transfer` command.

## Managing Tasks

To monitor the status of active transfers, use 

```bash
globus task list
```

or similarly you can use the web tool to verify transfers.


## References:

1. Globus Data Transfer, Rivanna HPC <https://www.rc.virginia.edu/userinfo/globus/>
