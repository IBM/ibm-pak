<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Check Certificate/Key Validity and Archives](#check-certificatekey-validity-and-archives)
  - [Check Certificate/Key Validity](#check-certificatekey-validity)
    - [Verify that the certificate/key is owned by IBM:](#verify-that-the-certificatekey-is-owned-by-ibm)
    - [Verify authenticity of certificate/key:](#verify-authenticity-of-certificatekey)
  - [Optionally Validate Each Certificate Individually](#optionally-validate-each-certificate-individually)
    - [Verify that the certificate is still active:](#verify-that-the-certificate-is-still-active)
    - [Verify that the intermediate certificate is still active:](#verify-that-the-intermediate-certificate-is-still-active)
  - [Verify Archive](#verify-archive)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Check Certificate/Key Validity and Archives

* [Check Certificate/Key Validity](#check-certificate/key-validity)
* [Optionally Validate Each Certificate Individually](#optionally-validate-each-certificate-individually)
* [Verify Archive](#verify-archive)

## Check Certificate/Key Validity

### Verify that the certificate/key is owned by IBM:
Note: On windows, run below commands from Git Bash

```
openssl x509 -inform pem -in ibm-pak-plugin.pem -noout -text
```

### Verify authenticity of certificate/key:

```
cat ibm-pak-plugin-chain0.pem > chain.pem
cat ibm-pak-plugin-chain1.pem >> chain.pem

openssl ocsp -no_nonce -issuer chain.pem -cert ibm-pak-plugin.pem -VAfile chain.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

## Optionally Validate Each Certificate Individually

### Verify that the certificate is still active:

```
openssl ocsp -no_nonce -issuer ibm-pak-plugin-chain0.pem -cert ibm-pak-plugin.pem -VAfile ibm-pak-plugin-chain0.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

### Verify that the intermediate certificate is still active:

```
openssl ocsp -no_nonce -issuer ibm-pak-plugin-chain1.pem -cert ibm-pak-plugin-chain0.pem -VAfile ibm-pak-plugin-chain1.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`


## Verify Archive

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