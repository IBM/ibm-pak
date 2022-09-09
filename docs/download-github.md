<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Download from github release](#download-from-github-release)
  - [MacOS](#macos)
  - [Linux x86-architecture](#linux-x86-architecture)
  - [Windows](#windows)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Download from github release

* [MacOS](#macos)
* [Linux](#linux-x86-architecture)
* [Windows](#windows)

## MacOS 

Example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-darwin-amd64.tar.gz -o oc-ibm_pak-darwin-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-darwin-amd64.tar.gz.sig -o oc-ibm_pak-darwin-amd64.tar.gz.sig
```

Example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-darwin-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-darwin-amd64.tar.gz.sig
```

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain0.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain1.pem
```

## Linux x86-architecture

Example using `curl`:
```
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-linux-amd64.tar.gz -o oc-ibm_pak-linux-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-linux-amd64.tar.gz.sig -o oc-ibm_pak-linux-amd64.tar.gz.sig
```

Example using `wget`:
```
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-linux-amd64.tar.gz
wget https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-linux-amd64.tar.gz.sig
```

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain0.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain1.pem
```

## Windows

Example (from PowerShell) using `curl`:
```
curl https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-windows-amd64.tar.gz -o oc-ibm_pak-windows-amd64.tar.gz
curl https://github.com/IBM/ibm-pak-plugin/releases/download/v1.2.1/oc-ibm_pak-windows-amd64.tar.gz.sig -o oc-ibm_pak-windows-amd64.tar.gz.sig
```

Retrieve the latest public keys (example with curl):
```
curl https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin.pem -o ibm-pak-plugin.pem
curl https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain0.pem -o ibm-pak-plugin-chain0.pem
curl https://raw.githubusercontent.com/IBM/ibm-pak-plugin/master/ibm-pak-plugin-chain1.pem -o ibm-pak-plugin-chain1.pem
```
