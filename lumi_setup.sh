#!/bin/bash

mkdir -p ".cache"

SCRIPT_DIR=$(dirname "$0")

cd "$SCRIPT_DIR"
source lumi_config.sh

mkdir -p $PYTHONUSERBASE

CMD="
source /opt/miniconda3/bin/activate pytorch
pip install -r $SCRIPT_DIR/requirements/lumi_requirements.txt --user
pip install .
echo 'Installation finished'
"

REAL_PWD="$(realpath "$PWD")"

singularity exec --pwd "$REAL_PWD" "$CONTAINER" bash -c "$CMD"