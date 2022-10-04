#!/bin/sh -l

set -eo pipefail

export HELMFILE_DIRECTORY=${1}
export STAGE=${2}

# Required by some applications, but not relevant for CI
export REFERENCE=helmfile-ci-linting

# Install helm plugins - cannot be done in the Dockerfile
rm -rf  ~/.local/share/helm/plugins/
helm plugin install https://github.com/futuresimple/helm-secrets
helm plugin install https://github.com/databus23/helm-diff
helm plugin install https://github.com/chartmuseum/helm-push

###########################################################
################## Replacing secrets.yaml #################
###########################################################

# Import a (not-so-)secret key for SOPS to encrypt our dummy secret.yaml files
gpg --import /sops_functional_tests_key.asc

# This key is the fingerprint of one of the public keys contained in the file above
export GPG_KEY_FINGERPRINT=FBC7B9E2A4F9289AC0C1D4843D16CEE4A27381B4

cd ${HELMFILE_DIRECTORY}

# Replace all secrets.yaml with our own secrets.yaml
# 
# Loop through the values/${STAGE} folder, and find all secrets.yaml
for secret_file in $(find . -name "secrets.yaml"); do
  # Keep the YAML structure of the secrets.yaml
  sed -i '/sops:/Q' ${secret_file}

  # Replace the encrypted values with "dummy"
  sed -i 's/ENC\[.*/dummy/' ${secret_file}

  # Replace those secrets.yaml with custom secrets.yaml
  sops -i --encrypt --pgp ${GPG_KEY_FINGERPRINT} ${secret_file}
done

helmfile template
helmfile lint --args --strict
