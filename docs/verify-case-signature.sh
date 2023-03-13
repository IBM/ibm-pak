#!/usr/bin/env bash
#
# Licensed Materials - Property of IBM
# Copyright IBM Corporation 2023. All Rights Reserved
# US Government Users Restricted Rights -
# Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# This is an internal component, bundled with an official IBM product.
# Please refer to that particular license for additional information.
#
# ./verify-case-signature --case path/to/case.tgz --key path/to/pub.key
#
# example:
#
# using openssl
#
# ./verify-case-signature.sh --case ./cases/ibm-cp-common-services-1.19.1.tgz --key ./pub_keys/ibm-pak.pem.pub.key --cert ./pub_keys/ibm-pak.pem.cer --cert-chain ./pub_keys/ibm-pak.pem.chain
#
# using cosign
#
# ./verify-case-signature.sh --case ./cases/ibm-cp-common-services-1.19.1.tgz --key ./pub_keys/ibm-pak.pem.pub.key

set -o errexit
set -o nounset
set -o pipefail

# Input arguments
case_path=
case_dir=
input_key=
input_cert=
input_chain=
tool=openssl

while test $# -gt 0; do
    case "$1" in
    --help)
        echo "$(basename "$0") - verify signature"
        echo " "
        echo "options:"
        echo "--help                    show help"
        echo "--case case.tgz           specify path to case tgz, whose signature is it be verified"
        echo "--key pub.key             specify path to public key"
        echo "--cert pem.cer            specify path to public ceritificate"
        echo "--cert-chain pem.chain    specify path to ceritificate chain"
        echo "--tool cosign             specify tool to verify (values: cosign, openssl) (default: openssl)"
        exit 0
        ;;
    --case)
        shift
        if test $# -gt 0; then
            case_path=$1
        else
            echo "no case path is specified"
            exit 1
        fi
        shift
        ;;
    --key)
        shift
        if test $# -gt 0; then
            input_key=$1
        else
            echo "no public key specified"
            exit 1
        fi
        shift
        ;;
    --cert)
        shift
        if test $# -gt 0; then
            input_cert=$1
        else
            echo "no public certificate specified"
            exit 1
        fi
        shift
        ;;
    --cert-chain)
        shift
        if test $# -gt 0; then
            input_chain=$1
        else
            echo "no public certificate chain specified"
            exit 1
        fi
        shift
        ;;
    --tool)
        shift
        if test $# -gt 0; then
            tool=$1
        else
            echo "no signature verification tool specified"
            exit 1
        fi
        shift
        ;;
    *)
        break
        ;;
    esac
done

[[ ! -e $case_path ]] && {
    echo "case path: $case_path does not exist"
    exit 1
}

# extract CASE if its in tgz form
[[ $case_path = *.tgz ]] && {
    case_dir=$(mktemp -d /tmp/casedir.XXXXXXXXXX)
    tar -xf "$case_path" -C "$case_dir" --strip-components 1
}

[[ -d $case_path ]] && case_dir=$case_path

case_signature_file=$case_dir/signature.yaml
case_digest_file=$case_dir/digests.yaml
case_signature=$(yq '.signature' "$case_signature_file")

# validations
[[ ! -f $case_signature_file ]] && {
    echo "cannot find $case_signature_file"
    exit 1
}

[[ ! -f $case_digest_file ]] && {
    echo "cannot find $case_digest_file"
    exit 1
}

[[ -z $input_key ]] && {
    echo "--key is required"
    exit 1
}

[[ ! "$tool" =~ ^(openssl|cosign)$ ]] && {
    echo "--tool $tool is not supported. use openssl or cosign"
    exit 1
}

command -v yq >/dev/null 2>&1 || {
    echo >&2 "requires yq but it's not installed. see https://mikefarah.gitbook.io/yq/"
    exit 1
}
command -v jq >/dev/null 2>&1 || {
    echo >&2 "requires jq but it's not installed. see https://stedolan.github.io/jq/"
    exit 1
}

recreate_signature_file=$(mktemp /tmp/case_signature.XXXXXX)
cp "$case_signature_file" "$recreate_signature_file"
DIGEST="sha256:$(sha256sum "$case_digest_file" | awk '{print $1}')" yq -i '.data.digest=env(DIGEST) | del (.signature)' "$recreate_signature_file"
canonical_json_file=$(mktemp /tmp/case_canonical_json.XXXXXX)
yq -o json "$recreate_signature_file" | jq -cjS >"$canonical_json_file"

echo "Verifying signature using $tool ..."
if [[ $tool == "cosign" ]]; then
    # verify using cosign
    cosign verify-blob --key "$input_key" --signature "$case_signature" "$canonical_json_file" --insecure-ignore-tlog
else
    encoded_signature=$(mktemp /tmp/case_encoded_signature.XXXXXX)
    decoded_signature=$(mktemp /tmp/case_decoded_signature.XXXXXX)
    echo "$case_signature" >"$encoded_signature"

    # verify signature using openssl
    openssl enc -d -A -base64 -in "$encoded_signature" -out "$decoded_signature"
    openssl dgst -verify "$input_key" -keyform PEM -sha256 -signature "$decoded_signature" -binary "$canonical_json_file"

    if [ -n "$input_chain" ] || [ -n "$input_cert" ]; then
        # verify cerificate is not expired
        echo "Verifying certificate status ..."
        openssl ocsp -no_nonce -issuer "$input_chain" -cert "$input_cert" -VAfile "$input_chain" -text -url http://ocsp.digicert.com -respout ocsptest
    fi
fi

# cleanup temp files
rm -rf "$case_dir" "$canonical_json_file" "$recreate_signature_file"

exit 0
