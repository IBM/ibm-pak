<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Manual CASE signature verification](#manual-case-signature-verification)
  - [Prereqs](#prereqs)
  - [Download public key and certificate](#download-public-key-and-certificate)
  - [Download the CASE](#download-the-case)
  - [Verify](#verify)
    - [Using OpenSSL](#using-openssl)
    - [Using Cosign](#using-cosign)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Manual CASE signature verification

This document contains instructions to verify if the signature in the downloaded CASE is valid using OpenSSL or Cosign.

NOTE: [ibm-pak](https://github.com/IBM/ibm-pak) CLI automatically verifies CASE signature during downloads.

## Prereqs

- Linux OS
- [yq](https://mikefarah.gitbook.io/yq/)
- [jq](https://stedolan.github.io/jq/)
- [openssl](https://www.openssl.org/)
- [cosign](https://github.com/sigstore/cosign/releases) (optional)


## Download public key and certificate

```bash
$ mkdir pub_keys
$ curl -sSfL https://github.com/IBM/ibm-pak/raw/main/certificates/ibm-pak-plugin.pem.pub.key -o ibm-pak.pem.pub.key
$ curl -sSfL https://github.com/IBM/ibm-pak/raw/main/certificates/ibm-pak-plugin.pem.cer -o ibm-pak.pem.cer
$ curl -sSfL https://github.com/IBM/ibm-pak/raw/main/certificates/ibm-pak-plugin.pem.chain -o ibm-pak.pem.chain
```

## Download the CASE

The easiest way to download a CASE is using [ibm-pak get](https://github.com/IBM/ibm-pak/blob/main/docs/command-help.md#oc-ibm-pak-get)

Example:

```bash
$ oc ibm-pak get ibm-cp-common-services --version 1.19.1
Downloading and extracting the CASE ...
- Success
Retrieving CASE version ...
- Success
Validating the CASE ...
Validating the signature for the ibm-cp-common-services CASE...
- Success
Creating inventory ...
- Success
Finding inventory items
- Success
Resolving inventory items ...
Parsing inventory items
Validating the signature for the ibm-auditlogging CASE...
Validating the signature for the ibm-cert-manager CASE...
Validating the signature for the ibm-cs-commonui CASE...
Validating the signature for the ibm-crossplane-bundle CASE...
Validating the signature for the ibm-events-operator CASE...
Validating the signature for the ibm-cs-healthcheck CASE...
Validating the signature for the ibm-cs-iam CASE...
Validating the signature for the ibm-cpp CASE...
Validating the signature for the ibm-zen CASE...
Validating the signature for the ibm-licensing CASE...
Validating the signature for the ibm-management-ingress CASE...
Validating the signature for the ibm-cs-mongodb CASE...
Validating the signature for the ibm-cs-monitoring CASE...
Validating the signature for the ibm-platform-api-operator CASE...
- Success
Download of CASE: ibm-cp-common-services, version: 1.19.1 is complete
Generating ComponentSetConfig of CASE: ibm-cp-common-services, version: 1.19.1 to /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/component-set-config.yaml is complete
```

The CASEs and its dependencies are now downloaded to ibm-pak workspace

```
$ ls /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/*.tgz
-rw-r--r--  1 jey  staff   109K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cp-common-services-1.19.1.tgz
-rw-r--r--  1 jey  staff    82K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-auditlogging-1.20.1.tgz
-rw-r--r--  1 jey  staff    86K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cert-manager-1.19.1.tgz
-rw-r--r--  1 jey  staff    63K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cs-commonui-1.21.1.tgz
-rw-r--r--  1 jey  staff   148K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-crossplane-bundle-1.12.1.tgz
-rw-r--r--  1 jey  staff   161K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-events-operator-4.4.0.tgz
-rw-r--r--  1 jey  staff   365K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cs-healthcheck-1.19.1.tgz
-rw-r--r--  1 jey  staff   319K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cs-iam-1.19.1.tgz
-rw-r--r--  1 jey  staff    78K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cpp-1.10.1.tgz
-rw-r--r--  1 jey  staff   108K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-zen-2.14.1.tgz
-rw-r--r--  1 jey  staff    70K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-licensing-1.20.1.tgz
-rw-r--r--  1 jey  staff    83K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-management-ingress-1.19.1.tgz
-rw-r--r--  1 jey  staff    49K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cs-mongodb-1.18.1.tgz
-rw-r--r--  1 jey  staff   316K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-cs-monitoring-1.19.1.tgz
-rw-r--r--  1 jey  staff    61K Mar  2 01:36 /Users/jey/.ibm-pak/data/cases/ibm-cp-common-services/1.19.1/ibm-platform-api-operator-1.19.1.tgz
```

## Verify

### Using OpenSSL

```bash
$ ./verify-case-signature.sh --case ./cases/ibm-cp-common-services-1.19.1.tgz --key ./pub_keys/ibm-pak.pem.pub.key --cert ./pub_keys/ibm-pak.pem.cer --cert-chain ./pub_keys/ibm-pak.pem.chain
Verifying signature using openssl ...
Verified OK
Verifying certificate status ...
OCSP Request Data:
    Version: 1 (0x0)
    Requestor List:
        Certificate ID:
          Hash Algorithm: sha1
          Issuer Name Hash: 915DEAC5D1E15E49646B8A94E04E470958C9BB89
          Issuer Key Hash: 6837E0EBB63BF85F1186FBFE617B088865F44E42
          Serial Number: 0445DBCE3132EF694BB86166F83486A1
OCSP Response Data:
    OCSP Response Status: successful (0x0)
    Response Type: Basic OCSP Response
    Version: 1 (0x0)
    Responder Id: 6837E0EBB63BF85F1186FBFE617B088865F44E42
    Produced At: Mar  4 12:12:44 2023 GMT
    Responses:
    Certificate ID:
      Hash Algorithm: sha1
      Issuer Name Hash: 915DEAC5D1E15E49646B8A94E04E470958C9BB89
      Issuer Key Hash: 6837E0EBB63BF85F1186FBFE617B088865F44E42
      Serial Number: 0445DBCE3132EF694BB86166F83486A1
    Cert Status: good
    This Update: Mar  4 11:57:01 2023 GMT
    Next Update: Mar 11 11:12:01 2023 GMT

    Signature Algorithm: sha384WithRSAEncryption
         88:ff:da:da:cc:f1:7f:12:6c:91:5b:d7:51:26:7c:db:4c:75:
         6a:0c:94:93:8a:5b:89:d7:03:30:da:0a:e2:22:31:2f:4c:d1:
         97:23:9e:e8:17:4f:d2:46:5d:d3:aa:97:43:67:97:c4:54:0d:
         05:51:89:f9:fb:17:2a:58:c7:60:7f:86:7b:ea:50:78:6c:ae:
         b0:7c:21:76:96:22:44:b2:c7:06:2c:d0:9b:71:94:58:f4:10:
         9e:17:7a:1b:c9:79:01:c3:75:13:96:83:9f:e2:00:ce:19:a9:
         de:3e:30:88:ed:d3:10:b3:da:b8:d3:d8:a7:1a:b9:b8:9b:5f:
         f3:6c:d5:b0:a0:23:4d:2a:2a:ce:e1:36:d8:b9:76:59:fa:4b:
         cf:3e:57:5b:2f:e7:21:b8:c9:48:2d:02:4b:61:02:fd:57:a3:
         39:b5:ac:1e:71:7c:c8:93:99:f1:71:e4:c9:b1:40:85:c7:a0:
         da:8b:6a:d8:3f:1b:58:c8:19:dd:2e:fe:a6:da:ea:f7:99:ca:
         5a:dd:75:be:31:f3:88:40:59:a0:28:91:13:a4:c2:a5:ed:a8:
         43:2f:a1:c4:ca:36:4a:04:88:eb:ae:0f:b0:80:a4:3b:1c:9b:
         93:ab:2e:20:73:70:ad:f6:1a:97:1d:32:c8:de:43:e5:0a:2e:
         14:8a:5e:fd:5a:b9:64:85:f0:dc:b6:ff:3e:06:09:f8:fb:65:
         af:d7:52:c2:55:7b:a3:cd:31:ce:1a:f6:f9:fc:cc:68:57:35:
         77:c0:60:0b:58:a1:ed:e1:c3:9d:ee:18:a7:13:e4:4a:44:86:
         2f:07:ff:a8:3e:77:7d:41:3b:0f:1e:95:66:43:56:29:9e:0c:
         58:c0:9d:79:c2:ed:2f:a0:ec:30:d9:c8:c9:8c:96:f9:2b:9d:
         1f:ba:b5:4e:91:e6:41:68:d2:26:c6:22:de:76:b2:85:59:60:
         c5:8f:e2:a3:71:dd:2b:e5:37:53:d1:0b:56:9c:18:d1:8b:da:
         09:b3:c7:1d:da:5c:60:98:fc:40:17:e0:a3:93:45:ef:72:cc:
         43:14:72:cb:e1:0f:28:9b:a0:2c:59:43:ee:4a:63:2f:d5:f0:
         5b:67:d8:a5:5e:e6:f1:d6:0d:4d:34:45:6f:a6:5d:31:18:2f:
         fe:07:73:a3:2e:b8:d9:0a:c7:68:32:e0:f0:46:be:ac:1b:12:
         cb:28:6d:28:89:c8:19:e2:ff:c5:ea:10:ad:2b:47:bd:02:4e:
         70:23:be:c2:ed:b4:9a:68:aa:44:d9:16:25:02:5b:b7:fc:55:
         9d:a3:ad:ea:54:18:d4:96:73:1a:f1:a3:4c:ef:d7:a6:17:20:
         9a:9a:58:96:64:0f:12:6e
Response verify OK
./pub_keys/ibm-pak.pem.cer: good
        This Update: Mar  4 11:57:01 2023 GMT
        Next Update: Mar 11 11:12:01 2023 GMT
```

### Using Cosign

```bash
./verify-case-signature.sh --case ./cases/ibm-cp-common-services-1.19.1.tgz --key ./pub_keys/ibm-pak.pem.pub.key --cert ./pub_keys/ibm-pak.pem.cer --cert-chain ./pub_keys/ibm-pak.pem.chain --tool cosign
Verifying signature using cosign ...
Verified OK
```
