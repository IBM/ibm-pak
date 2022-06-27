<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Supported paths](#supported-paths)
  - [Download and verify software](#download-and-verify-software)
    - [Download from github release](#download-from-github-release)
    - [Download from IBM container registry](#download-from-ibm-container-registry)
    - [Check Certificate/Key Validity](#check-certificatekey-validity)
      - [Verify that the certificate/key is owned by IBM:](#verify-that-the-certificatekey-is-owned-by-ibm)
      - [Verify authenticity of certificate/key:](#verify-authenticity-of-certificatekey)
    - [Optionally Validate Each Certificate Individually](#optionally-validate-each-certificate-individually)
      - [Verify that the certificate is still active:](#verify-that-the-certificate-is-still-active)
      - [Verify that the intermediate certificate is still active:](#verify-that-the-intermediate-certificate-is-still-active)
    - [Verify Archive](#verify-archive)
  - [Install](#install)
  - [Configure the locale - Optional step](#configure-the-locale---optional-step)
  - [Download the CASE](#download-the-case)
  - [Generate Mirror Manifests](#generate-mirror-manifests)
    - [Bastion Host path](#bastion-host-path)
    - [Filesystem path](#filesystem-path)
  - [Mirroring](#mirroring)
    - [Authenticating the registry](#authenticating-the-registry)
    - [Bastion Host path](#bastion-host-path-1)
    - [Filesystem path](#filesystem-path-1)
  - [Update the global image pull secret](#update-the-global-image-pull-secret)
  - [Create ImageContentSourcePolicy](#create-imagecontentsourcepolicy)
  - [Launch Command: Install A Catalog](#launch-command-install-a-catalog)
  - [For macOS Catalina users](#for-macos-catalina-users)
  - [Support](#support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Overview

This repository provides the IBM Catalog Management Plug-in for IBM Cloud Paks 1.0 (Tech preview) via its github releases. The plugin streamlines the deployment of IBM CloudPaks in a disconnected environment which was done earlier using [cloudctl] (https://github.com/IBM/cloud-pak-cli).

## Prerequisites

* A container image registry that supports [Docker v2-2](https://docs.docker.com/registry/spec/manifest-v2-2). We will refer to that registry as `TARGET_REGISTRY`. You will mirror your images to this `TARGET_REGISTRY`. The Openshift cluster should have access to it so that it can pull images from this registry when you [install the catalog](#launch-command-install-a-catalog). See [Creating a mirror registry](https://docs.openshift.com/container-platform/4.10/installing/disconnected_install/installing-mirroring-creating-registry.html) as a reference if you don't already have a registry.
  
* Download and install [oc](https://docs.openshift.com/container-platform/4.10/cli_reference/openshift_cli/getting-started-cli.html).

## Supported paths

1. `Bastion Host` -  A bastion server is a device that has access to both the public internet and the local intranet where a local registry and Red Hat OpenShift Container Platform clusters reside. Using the bastion server, you can replicate your images through the bastion server directly to the local, intranet registry (the TARGET_REGISTRY) behind the firewall. 


2. `Filesystem` - You can mirror the images to a local Filesystem on a hard disk drive that can be connected to a compute device external to your firewall to download the images. This portable storage can then be connected to a device behind the firewall so that the images can be loaded to the local, intranet registry (the TARGET_REGISTRY)

The steps to install the IBM CloudPaks are similar for both the paths, and outlined wherever they differ.
## Download and verify software

There are two ways to obtain the plugin
* [Github Release](#download-from-github-release)
* [Container image](#download-from-ibm-container-registry)

### Download from github release

1. Download the gzipped tar archive for your OS from the assets in [releases](https://github.com/IBM/ibm-pak-plugin/releases)
2. Download the corresponding `.sig` file for verification purposes

macOS example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-darwin-amd64.tar.gz -o oc-ibm_pak-darwin-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-darwin-amd64.tar.gz.sig -o oc-ibm_pak-darwin-amd64.tar.gz.sig
```

macOS example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-darwin-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-darwin-amd64.tar.gz.sig
```

Linux x86-architecture example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-linux-amd64.tar.gz -o oc-ibm_pak-linux-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-linux-amd64.tar.gz.sig -o oc-ibm_pak-linux-amd64.tar.gz.sig
```

Linux x86-architecture example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-linux-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.0.0/oc-ibm_pak-linux-amd64.tar.gz.sig
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
| 1.1.0         | v1.1.0         |
| 1.0.0         | v1.0.0         |
| 1.0.0-alpha.0 | v1.0.0-alpha.0 |

The following command will create a container and copy the plug-ins for all the supported platforms in a directory, plugin-dir. You can specify any directory name and it will be created while copying. After copying, it will delete the temporary container. The plugin-dir will have all the binaries and other artifacts you find in a Github release and repo at [IBM/ibm-pak-plugin](https://github.com/IBM/ibm-pak-plugin). Choose the Image tag from the above table. For example,

1. If you use docker:

```
id=$(docker create cp.icr.io/cpopen/cpfs/ibm-pak:1.0.0 - )
docker cp $id:/ibm-pak-plugin plugin-dir
docker rm -v $id
cd plugin-dir
``` 

2. If you podman:

```
id=$(podman create cp.icr.io/cpopen/cpfs/ibm-pak:1.0.0 - )
podman cp $id:/ibm-pak-plugin plugin-dir
podman rm -v $id
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




## Install

1. Extract the downloaded plugin and copy to executable PATH. 
  
NOTE:

- While copying, the destination name should be `oc-ibm_pak` and cannot be changed.
- On Mac before copying oc-ibm_pak-darwin-amd64 to /usr/local/bin/oc-ibm_pak or any directory in your PATH, refer to [For macOS Catalina users](#for-macos-catalina-users)
- If /usrlocal/bin is not accessible then place it in an accessible folder and put that folder in PATH
- See accompanying LICENSE file obtained on extracting for the allowed usage.

For example on Mac,

```bash
tar -xvf oc-ibm_pak-darwin-amd64.tar.gz
cp oc-ibm_pak-darwin-amd64 /usr/local/bin/oc-ibm_pak
```


Verify that the installation was successful by issuing the below command

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
  IBMPAK_HOME                     the directory path where all plugin results will be saved (default "user's home directory")
  IBMPAK_TOLERANCE_RETRY          when set to false, launch script execution failure will not be retried
                                  when set to true, launch script execution failures will be retried without the --tolerance flag (default "true")
  IBMPAK_RESOLVE_DEPENDENCIES     when set to false, no CASE references will be resolved (default "true")
  IBMPAK_LAUNCH_SKIP_PREREQ_CHECK when set to true, will skip checking prerequisites in the launch framework (default "false")
  IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "10")
  HTTPS_PROXY or https_proxy      the URL of a HTTPS proxy (e.g. https://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
  HTTP_PROXY or http_proxy        the URL of a HTTP proxy (e.g. http://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
```

## Configure the locale - Optional step

The plug-in can detect the locale of your environment and provide textual helps and messages accordingly. You can optionally set the locale by running the following command:

```sh
oc ibm-pak config locale -l LOCALE
```
where LOCALE can be one of de_DE, en_US, es_ES, fr_FR, it_IT, ja_JP, ko_KR, pt_BR, zh_Hans, zh_Hant.

## Download the CASE

Download the "top level" CASE and all of its direct and transitive dependencies.

```bash
export CASE_NAME=ibm-cp-common-services
export CASE_VERSION=1.15.0
oc ibm-pak get $CASE_NAME --version $CASE_VERSION
```

This will create a directory `~/.ibm-pak` and downloaded the CASE under `~/.ibm-pak/data/cases/$CASE_NAME/$CASE_VERSION`. We call `~/.ibm-pak` as the plugin root or home directory.
You can change the plugin's root directory by exporting IBMPAK_HOME environment variable.

## Generate Mirror Manifests


### Bastion Host path

If you are following the `Bastion Host` path then issue the below command to generate the following files:

* `images-mapping.txt` which contains a mapping of `source image` and `destination image` separted by `=` and 
* `image-content-source-policy.yaml` which defines `ImageContentSourcePolicy` 

```bash
export TARGET_REGISTRY=mytargetregistry.com
oc ibm-pak generate mirror-manifests $CASE_NAME $TARGET_REGISTRY --version $CASE_VERSION
```

Issue the below command to see which images will be mirrored to your TARGET_REGISTRY. The output shows `Source` from where the images will be pulled and `Destination` where they will be mirrored. It also shows all the different registries in `* Registries found *` section where are referenced by images in `Source`.

```bash
oc ibm-pak describe $CASE_NAME --version $CASE_VERSION --list-mirror-images
```

### Filesystem path

If you are following the `Filesystem` path then issue the below command to generate the following files
* `images-mapping-to-filesystem.txt` 
* `images-mapping-from-filesystem.txt` and
* `image-content-source-policy.yaml`

```bash
oc ibm-pak generate mirror-manifests \
    $CASE_NAME \
    file://local \
    --version $CASE_VERSION \
    --final-registry $TARGET_REGISTRY
```

If you do not know the value of the final registry where the images will be mirrored, you can provide a placeholder value of TARGET_REGISTRY. For example: `oc ibm-pak generate mirror-manifests $CASE_NAME file://cpfs --version $CASE_VERSION --final-registry TARGET_REGISTRY`. Note that TARGET_REGISTRY used without any environment variable expansion is just a plain string that you will replace later with the actual image registry URL when it is known to you.

## Mirroring

Before you mirror the images you must authenticate the registry so that `oc image mirror` can access the images and push to your TARGET_REGISTRY.

### Authenticating the registry

Complete the following steps to authenticate your registries:

You must run the following command to configure credentials for all target registries that require authentication. Run the command separately for each registry. There are two ways to do that as outlined below, Podman and Docker.

 1. `Podman`:
```
export REGISTRY_AUTH_FILE=<path to the file which will store the auth credentials generated on podman login>
podman login cp.icr.io
podman login <TARGET_REGISTRY>
```

For example, if you export `REGISTRY_AUTH_FILE=~/.ibm-pak/auth.json`, then after performing podman login, you can see that the file is populated with registry credentials.


2. `Docker`:
If you use `docker login`, the authentication file is typically located at `$HOME/.docker/config.json` on Linux or `%USERPROFILE%/.docker/config.json` on Windows. After docker login you should export `REGISTRY_AUTH_FILE` to point to that location. For example in Linux you can issue the following command:

```
docker login cp.icr.io
docker login <TARGET_REGISTRY>
export REGISTRY_AUTH_FILE=$HOME/.docker/config.json
```


### Bastion Host path

If you are following the `Bastion Host` path then issue the below command to mirror the images to your TARGET_REGISTRY:

```bash
export TARGET_REGISTRY=mytargetregistry.com
oc image mirror \
  -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping.txt \
  --filter-by-os '.*'  \
  -a $REGISTRY_AUTH_FILE \
  --insecure  \
  --skip-multiple-scopes \
  --max-per-registry=1
```

### Filesystem path

If you are following the `Filesystem` path then issue the below command to mirror the images to your filesystem first.

```bash
oc image mirror \
  -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping-to-filesystem.txt \
  --filter-by-os '.*' \
  -a $REGISTRY_AUTH_FILE \
  --insecure \
  --skip-multiple-scopes \
  --max-per-registry=1
```

This will create a v2 folder in the current directory where all the images are copied. For example, in [the previous section](#filesystem-path) if provided file://local as input during generate mirror-manifests then the preceding command will create a subdirectory local under v2 and copy the images under it.

Continue to move the following items to your another machine behind the firewall which has access to your TARGET_REGISTRY:
 * v2 directory
 * The auth file referred by $REGISTSRY_AUTH_FILE and
 *  ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping-from-filesystem.txt


On your another machine where you copied all the above files, issue the below command to mirror images from the Filesystem to the TARGET_REGISTRY

**NOTE** - If you used the placeholder value of TARGET_REGISTRY as a parameter to --final-registry at the time of [generating mirror manifests](), then before running the following command, find and replace the placeholder value of TARGET_REGISTRY in the file, images-mapping-from-filesystem.txt, with the actual registry where you want to mirror the images. For example, if you want to mirror images to myregistry.com/mynamespace then replace TARGET_REGISTRY with myregistry.com/mynamespace.

```bash
oc image mirror \
  -f ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/images-mapping-from-filesystem.txt \
  -a $REGISTRY_AUTH_FILE \
  --from-dir=${v2_dir} \
  --filter-by-os '.*' \
  --insecure \
  --skip-multiple-scopes \
  --max-per-registry=1
```

`$v2_dir` refers to the parent directory on the file system where the v2 directory was copied to.

All the subsequent sections require you to be logged into your Openshift cluster.

## Update the global image pull secret 

Update the global image pull secret for your Red Hat OpenShift cluster. Follow the steps in [Updating the global cluster pull secret](https://docs.openshift.com/container-platform/4.10/openshift_images/managing_images/using-image-pull-secrets.html#images-update-global-pull-secret_using-image-pull-secrets). The documented steps in the link enable your cluster to have proper authentication credentials in place to pull images from your TARGET_REGISTRY as specified in the image-content-source-policy.yaml which you will apply to your cluster in the next step.


## Create ImageContentSourcePolicy

If your TARGET_REGISTRY is insecure, you must add it to the cluster insecureRegistries list.

```bash
oc patch image.config.openshift.io/cluster --type=merge \
-p '{"spec":{"registrySources":{"insecureRegistries":["'${TARGET_REGISTRY}'"]}}}'
```


If you are following the `Filesystem path` and used the placeholder value of TARGET_REGISTRY as a parameter to --final-registry at the time of generating mirror manifests, then before running the following command, find and replace the placeholder value of TARGET_REGISTRY in file, ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/image-content-source-policy.yaml with the actual registry where you want to mirror the images. For example, replace TARGET_REGISTRY with myregistry.com/mynamespace.

**Important** If you are using Red Hat OpenShift Container Platform version 4.7 or earlier, then this step might cause your cluster nodes to drain and restart sequentially to apply the configuration changes.


```bash
oc apply -f  ~/.ibm-pak/data/mirror/$CASE_NAME/$CASE_VERSION/image-content-source-policy.yaml
```


Monitor cluster node status
```bash
oc get MachineConfigPool -w
```

Wait until all MachineConfigPools are updated.

## Launch Command: Install A Catalog


Issue the following command to initiate the install-catalog action for the top level CASE:

```bash
export NAMESPACE=ibm-common-services
export CASE_INVENTORY_SETUP=ibmCommonServiceOperatorSetup
oc ibm-pak launch \
$CASE_NAME \
  --version $CASE_VERSION \
  --action install-catalog \
  --inventory $CASE_INVENTORY_SETUP \
  --namespace $NAMESPACE \
  --args "--registry $TARGET_REGISTRY --recursive \
  --inputDir ~/.ibm-pak/data/cases/$CASE_NAME/$CASE_VERSION"
```
Provide an inventory based on the CASE you are installing. We have been referring to `ibm-cp-common-services` hence we used `ibmCommonServiceOperatorSetup` as inventory.
## For macOS Catalina users

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

