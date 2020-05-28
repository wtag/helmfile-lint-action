#!/bin/sh -l

set -eo pipefail

export HELMFILE_DIRECTORY=${1}
export STAGE=${2}

cd ${HELMFILE_DIRECTORY}
helmfile template
helmfile lint
