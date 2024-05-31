<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents** _generated with [DocToc](https://github.com/thlorenz/doctoc)_

- [Download plugin from github release](#download-plugin-from-github-release)
  - [MacOS](#macos)
  - [Linux x86-architecture](#linux-x86-architecture)
  - [Linux ppc64le-architecture](#linux-ppc64le-architecture)
  - [Linux s390x-architecture](#linux-s390x-architecture)
  - [Windows](#windows)
- [Download public keys for ibm-pak versions less than v1.5.0](#download-public-keys-for-ibm-pak-versions-less-than-v150)
- [Download public keys for ibm-pak versions greater than or equal to v1.5.0](#download-public-keys-for-ibm-pak-versions-greater-than-or-equal-to-v150)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Download plugin from github release

## MacOS

Example using `curl`:

```
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-darwin-amd64.tar.gz -o oc-ibm_pak-darwin-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-darwin-amd64.tar.gz.sig -o oc-ibm_pak-darwin-amd64.tar.gz.sig
```

Example using `wget`:

```
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-darwin-amd64.tar.gz
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-darwin-amd64.tar.gz.sig
```

## Linux x86-architecture

Example using `curl`:

```
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-amd64.tar.gz -o oc-ibm_pak-linux-amd64.tar.gz
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-amd64.tar.gz.sig -o oc-ibm_pak-linux-amd64.tar.gz.sig
```

Example using `wget`:

```
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-amd64.tar.gz
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-amd64.tar.gz.sig
```

## Linux ppc64le-architecture

Example using `curl`:

```
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-ppc64le.tar.gz -o oc-ibm_pak-linux-ppc64le.tar.gz
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-ppc64le.tar.gz.sig -o oc-ibm_pak-linux-ppc64le.tar.gz.sig
```

Example using `wget`:

```
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-ppc64le.tar.gz
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-ppc64le.tar.gz.sig
```

## Linux s390x-architecture

Example using `curl`:

```
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-s390x.tar.gz -o oc-ibm_pak-linux-s390x.tar.gz
curl -L https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-s390x.tar.gz.sig -o oc-ibm_pak-linux-s390x.tar.gz.sig
```

Example using `wget`:

```
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-s390x.tar.gz
wget https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-linux-s390x.tar.gz.sig
```

## Windows

Example (from PowerShell) using `curl`:

```
curl https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-windows-amd64.tar.gz -o oc-ibm_pak-windows-amd64.tar.gz
curl https://github.com/IBM/ibm-pak/releases/download/v1.15.1/oc-ibm_pak-windows-amd64.tar.gz.sig -o oc-ibm_pak-windows-amd64.tar.gz.sig
```

# Download public keys for ibm-pak versions less than v1.5.0

Retrieve the latest public keys (example with wget):

```
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin-chain0.pem
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin-chain1.pem
```

Retrieve the latest public keys (example with curl):

```
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin.pem -o ibm-pak-plugin.pem
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin-chain0.pem -o ibm-pak-plugin-chain0.pem
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/ibm-pak-plugin-chain1.pem -o ibm-pak-plugin-chain1.pem
```

# Download public keys for ibm-pak versions greater than or equal to v1.5.0

Retrieve the latest public keys (example with wget):

```
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.cer
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.chain
wget https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.pub.key
```

Retrieve the latest public keys (example with curl):

```
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.cer -o ibm-pak-plugin.pem.cer
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.chain -o ibm-pak-plugin.pem.chain
curl https://raw.githubusercontent.com/IBM/ibm-pak/main/certificates/ibm-pak-plugin.pem.pub.key -o ibm-pak-plugin.pem.pub.key
```
