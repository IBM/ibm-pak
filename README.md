# Overview

This repository provides the IBM Catalog Management Plug-in for IBM Cloud Paks 1.0 (Tech preview) via its github releases. The plugin streamlines the deployment of IBM CloudPaks in a disconnected environment which was done earlier using [cloudctl] (https://github.com/IBM/cloud-pak-cli)

## Download and verify software

### Download from github release

1. Download the gzipped tar archive for your OS from the assets in [releases](https://github.com/IBM/ibm-pak-plugin/releases)
2. Download the corresponding `.sig` file for verification purposes

macOS example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-darwin-amd64.tar.gz -o oc-ibm_pak-darwin-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-darwin-amd64.tar.gz.sig -o oc-ibm_pak-darwin-amd64.tar.gz.sig
```

macOS example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-darwin-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-darwin-amd64.tar.gz.sig
```

Linux x86-architecture example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz -o oc-ibm_pak-linux-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz.sig -o oc-ibm_pak-linux-amd64.tar.gz.sig
```

Linux x86-architecture example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/latest/download/oc-ibm_pak-linux-amd64.tar.gz.sig
```

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain0.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain1.pem
```


### Download from IBM container registry

The plugin is also provided in a container image `cp.icr.io/cpopen/cpfs/ibm-pak:TAG`

The following table shows the mapping between container image TAG and the plugin release version

| Image tag     | Plugin version |
|---------------|----------------|
| 1.0.0-alpha.0 | v1.0.0-alpha.0 |

The following command will create a container and copy the plug-ins for all the supported platforms in a directory, plugin-dir. You can specify any directory name and it will be created while copying. After copying, it will delete the temporary container. The plugin-dir will have all the binaries and other artifacts you find in a Github release and repo at [IBM/ibm-pak-plugin](https://github.com/IBM/ibm-pak-plugin). Choose the Image tag from the above table and use that as the value of TAG below.

```
id=$(docker create cp.icr.io/cpopen/cpfs/ibm-pak:TAG - )
docker cp $id:/ibm-pak-plugin plugin-dir
docker rm -v $id
cd plugin-dir
``` 

### Check Certificate/Key Validity

#### Verify that the certificate/key is owned by IBM:

```
openssl x509 -inform pem -in ibm-pak-plugin.pem -noout -text
```

#### Verify authenticity of certificate/key:

```
cat ibm-pak-plugin-chain0.pem > chain.pem
cat ibm-pak-plugin-chain1.pem >> chain.pem

openssl ocsp -no_nonce -issuer chain.pem -cert ibm-pak-plugin.pem -VAfile chain.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

### Optionally Validate Each Certificate Individually

#### Verify that the certificate is still active:

```
openssl ocsp -no_nonce -issuer ibm-pak-plugin-chain0.pem -cert ibm-pak-plugin.pem -VAfile ibm-pak-plugin-chain0.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

#### Verify that the intermediate certificate is still active:

```
openssl ocsp -no_nonce -issuer ibm-pak-plugin-chain1.pem -cert ibm-pak-plugin-chain0.pem -VAfile ibm-pak-plugin-chain1.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`


### Verify Archive

After completing verification of the certificate, extract public key:

```
openssl x509 -pubkey -noout -in ibm-pak-plugin.pem > public.key
```

The public key is used to verify the tar archive:

```
openssl dgst -sha256 -verify public.key -signature <oc-ibm_pak_signature_file> <tar.gz_file>
```

e.g.

```
openssl dgst -sha256 -verify public.key -signature oc-ibm_pak-linux-amd64.tar.gz.sig oc-ibm_pak-linux-amd64.tar.gz
```

Should see a message that contains:

`Verified OK`


## Getting started

### Install

1. Download and install [oc](https://docs.openshift.com/container-platform/4.8/cli_reference/openshift_cli/getting-started-cli.html).
2. Download the plugin binary tgz from [releases](https://github.com/IBM/ibm-pak-plugin/releases).
3. Extract and copy to executable PATH.

```bash
$ tar -xvf oc-ibm_pak-darwin-amd64.tar.gz
$ cp oc-ibm_pak-darwin-amd64 /usr/local/bin/oc-ibm_pak
```

NOTE:

- While copying, the destination name should be `oc-ibm_pak` and cannot be changed.
- Plugin determines the command path that it will implement based on its filename.
- If /usrlocal/bin is not accessible then place it in an accessible folder and put that folder in PATH
4. See accompanying LICENSE file for the usage.
### Usage

```bash
$ oc ibm-pak --help
Deploy IBM Cloud Paks in a disconnected environment or generate image mirror manifest files

Usage:
  oc ibm-pak

Available Commands:
  config      Displays changes to configuration file used by this plugin
  describe    Describe command prints image lists, dependencies, registries and other information for this CASE
  generate    Generate command
  get         Download a Pak from source repository
  help        Help about any command
  launch      Launch a CASE into the targeted cluster.

Flags:
  -h, --help              help for ibm-pak
      --log_file string   If non-empty, use this log file
  -v, --v Level           number for the log level verbosity [0 (normal), 1 (fine), 2 (finer)or 3 (finest)]
      --version           print version (optional)

Use "oc ibm-pak [command] --help" for more information about a command.

Environment Variables:
  IBMPAK_HOME                     the directory path where all plugin results will be saved (default "plugin home directory")
  IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "10")
  IBMPAK_LAUNCH_SKIP_PREREQ_CHECK when set to true, will skip checking prerequisites in the launch framework (default "false")
  IBMPAK_RESOLVE_DEPENDENCIES     when set to false, no CASE references will be resolved (default "true")
  IBMPAK_TOLERANCE_RETRY          when set to false, launch script execution failure will not be retried
                                  when set to true, launch script execution failures will be retried without the --tolerance flag (default "true")
  HTTPS_PROXY or https_proxy      the URL of a HTTPS proxy (e.g. https://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
  HTTP_PROXY or http_proxy        the URL of a HTTP proxy (e.g. http://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
```

### Example Flows

The following illustrates the high level flow of commands used to mirror images as well as the launch function.

#### Get Command

This example fetches the "top level" CASE and all of its direct and transitive dependencies.

```bash
export CASE_NAME=ibm-cp-common-services
export CASE_VERSION=1.13.0
oc ibm-pak get $CASE_NAME --version $CASE_VERSION
```

#### Authenticating the registry

Complete the following steps to authenticate your registries:

You must run the following command to configure credentials for all target registries that require authentication. Run the command separately for each registry:

```
export REGISTRY_AUTH_FILE=<path to the file which will store the auth credentials generated on podman login>
podman login cp.icr.io
podman login <TARGET_REGISTRY>
```

For example, if you export `REGISTRY_AUTH_FILE=~/.ibm-pak/auth.json`, then after performing podman login, you can see that the file is populated with registry credentials.

If you use `docker login`, the authentication file is typically located at `$HOME/.docker/config.json` on Linux or `%USERPROFILE%/.docker/config.json` on Windows. After docker login you should export `REGISTRY_AUTH_FILE` to point to that location. For example in Linux you can issue the following command:

```
export REGISTRY_AUTH_FILE=$HOME/.docker/config.json
```

#### Generate Command: Mirror To Registry

This example generates the `images-mapping.txt` file that can be used with `oc image mirror`.

```bash
export TARGET_REGISTRY=mytargetregistry.com
oc ibm-pak generate mirror-manifests $CASE_NAME $TARGET_REGISTRY --version $CASE_VERSION
oc image mirror -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt  -a $REGISTRY_AUTH_FILE --filter-by-os=.* --insecure --skip-multiple-scopes --max-per-registry=1
```
#### Generate Command: Mirror To Filesystem And Then Registry

This example generates the `images-mapping-to-filesystem.txt` and `images-mapping-from-filesystem.txt` files that can be used with `oc image mirror`. This enables the ability to mirror images to the filesystem (into the `v2` direrectory), manually copy the filesystem contents to another machine behind the customer's firewall, and then mirror from the filesystem into the final regsitry used by the cluster.

```bash
oc ibm-pak generate mirror-manifests $CASE_NAME file://local --version $CASE_VERSION --final-registry $TARGET_REGISTRY
oc image mirror -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping-to-filesystem.txt -a $REGISTRY_AUTH_FILE --filter-by-os=.* --insecure --skip-multiple-scopes --max-per-registry=1

# manually copy filesystem v2 directory contents to new machine

oc image mirror -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping-from-filesystem.txt -a $REGISTRY_AUTH_FILE --filter-by-os=.* --insecure --skip-multiple-scopes --max-per-registry=1
```

#### Launch Command: Install A Catalog

This example uses the lauch capability to initiate the install-catalog action for the top level CASE:

```bash
oc ibm-pak launch --case ~/.ibm-pak/data/cases/$CASE_NAME/$CASE_VERSION/$CASE_NAME-$CASE_VERSION.tgz --action install-catalog --inventory ibmCommonServiceOperatorSetup --namespace foo --args "--registry $TARGET_REGISTRY"
```

### For macOS Catalina users

Users on macOS Catalina might be prompted that `oc-ibm_pak-darwin-amd64` is not a trusted application. There are two ways to get around this:

- Open Finder, control-click  the application `oc-ibm_pak-darwin-amd64`, choose **Open** from the menu, and then click **Open** in the dialog that appears. Enter your admin name and password to open the app if promoted.

- Enable developer-mode for your terminal window, which will allow everything. Make sure you are OK with this approach:
  -  Open Terminal, and enter:
       ```console
       ❯ spctl developer-mode enable-terminal 
      ```
  - Go to System Preferences -> Security & Privacy -> Privacy Tab -> Developer Tools -> Terminal : Enable
  - Restart all terminals

_See https://support.apple.com/en-ca/HT202491 for more information_

## Support

To report an issue or get help please visit https://www.ibm.com/docs/en/cpfs?topic=support-opening-case

