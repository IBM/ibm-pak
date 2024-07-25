<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [Overview](#overview)
  - [Download and verify software](#download-and-verify-software)
    - [Download from github release](#download-from-github-release)
    - [Download from IBM container registry](#download-from-ibm-container-registry)
    - [Check Certificate/Key Validity and Archives](#check-certificatekey-validity-and-archives)
  - [Install the plugin](#install-the-plugin)
  - [Installing your IBM Cloud Pak by mirroring Cloud Pak images to a private container registry](#installing-your-ibm-cloud-pak-by-mirroring-cloud-pak-images-to-a-private-container-registry)
  - [For macOS Catalina users](#for-macos-catalina-users)
  - [Support](#support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Overview

This repository provides the IBM Catalog Management Plug-in for IBM Cloud Paks via its github releases. The plugin streamlines the deployment of IBM CloudPaks in a disconnected environment which was done earlier using [cloudctl](https://github.com/IBM/cloud-pak-cli).

## Download and verify software

There are two ways to obtain the plugin

- [Github Release](#download-from-github-release)
- [Container image](#download-from-ibm-container-registry)

### Download from github release

1. Download the gzipped tar archive for your OS from the assets in [releases](https://github.com/IBM/ibm-pak/releases)
2. Download the corresponding `.sig` file for verification purposes

[Download for your OS](docs/download-github.md)

### Download from IBM container registry

The plugin is also provided in a container image `cp.icr.io/cpopen/cpfs/ibm-pak:TAG` where `TAG` should be replaced with the corresponding plugin version, for example `cp.icr.io/cpopen/cpfs/ibm-pak:v1.15.2` will have `v1.15.2` of the plugin.

The following command will create a container and copy the plug-ins for all the supported platforms in a directory, `plugin-dir`. You can specify any directory name and it will be created while copying. After copying, it will delete the temporary container. The `plugin-dir` will have all the binaries and other artifacts you find in a Github release and repo at [IBM/ibm-pak](https://github.com/IBM/ibm-pak). For example,

1. If you use docker:

```
id=$(docker create cp.icr.io/cpopen/cpfs/ibm-pak:v1.15.2 - )
docker cp $id:/ibm-pak-plugin plugin-dir
docker rm -v $id
cd plugin-dir
```

2. If you podman:

```
id=$(podman create cp.icr.io/cpopen/cpfs/ibm-pak:v1.15.2 - )
podman cp $id:/ibm-pak-plugin plugin-dir
podman rm -v $id
cd plugin-dir
```

### Check Certificate/Key Validity and Archives

- [ibm-pak versions less than v1.5.0](docs/verify.md)

- [ibm-pak versions greater than or equal to v1.5.0](docs/verify-v2.md)

## Install the plugin

1. Extract the downloaded plugin and copy to executable PATH.

NOTE:

- While copying, the destination name must be `oc-ibm_pak` (On windows, name must be `oc-ibm_pak.exe`) and cannot be changed including the dash and the underscore. These special characters are used by the oc command to find and setup the plugin
- On Mac before copying oc-ibm_pak-darwin-amd64 to `/usr/local/bin/oc-ibm_pak` or any directory in your PATH, refer to [For macOS Catalina users](#for-macos-catalina-users)
- If `/usr/local/bin` is not accessible then place it in an accessible folder and put that folder in PATH
- On windows, copy `oc-ibm_pak-windows-amd64` to `$HOME\AppData\Local\Microsoft\WindowsApps\oc-ibm_pak.exe` or any directory and add this path to PATH environment variable.
- See accompanying LICENSE file obtained on extracting for the allowed usage.

For example on Mac,

```bash
tar -xvf oc-ibm_pak-darwin-amd64.tar.gz
cp oc-ibm_pak-darwin-amd64 /usr/local/bin/oc-ibm_pak
```

For example on Windows (from PowerShell),

```powershell
tar -xvf oc-ibm_pak-windows-amd64.tar.gz
Copy-Item oc-ibm_pak-windows-amd64 $HOME\AppData\Local\Microsoft\WindowsApps\oc-ibm_pak.exe
```

Verify that the installation was successful by issuing the below command

```bash
oc ibm-pak --help
```

Information about plugin's available commands is described [in the doc](docs/command-help.md).

## Installing your IBM Cloud Pak by mirroring Cloud Pak images to a private container registry

Steps are described [here](https://www.ibm.com/docs/en/cloud-paks/1.0?topic=plugin-installing-by-connected-disconnected-mirroring).
For more information about available CASE names and versions, see [IBM: Product CASE to Application Version](https://ibm.github.io/cloud-pak/).

Starting with `v1.8.0`, the plug-in lays the foundation for eventual support for catalog-based mirroring. Information about catalog-based mirroring is described [in the doc](docs/catalog-mirroring.md). At this time, catalog-based mirroring and `oc-mirror` tool usage is a **_Tech Preview_** feature, which may not be supported by all products.

## For macOS Catalina users

Users on macOS Catalina might be prompted that `oc-ibm_pak-darwin-amd64` is not a trusted application. There are two ways to get around this:

- Open Finder, control-click the application `oc-ibm_pak-darwin-amd64`, choose **Open** from the menu, and then click **Open** in the dialog that appears. Enter your admin name and password to open the app if promoted.

- Enable developer-mode for your terminal window, which will allow everything. Make sure you are OK with this approach:
  - Open Terminal, and enter:
    ```console
    ❯ spctl developer-mode enable-terminal
    ```
  - Go to System Preferences -> Security & Privacy -> Privacy Tab -> Developer Tools -> Terminal : Enable
  - Restart all terminals

_See https://support.apple.com/en-ca/HT202491 for more information_

## Support

To report an issue or get help please visit https://www.ibm.com/docs/en/cpfs?topic=support-opening-case
