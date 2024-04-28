#!/bin/bash

REAL_PWD="$(realpath "$PWD")"
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

source lumi_config.sh

export XDG_CACHE_HOME=$REAL_PWD/.cache
export PIP_CACHE_DIR=$REAL_PWD/.cache/pip
export HF_HOME=$REAL_PWD/.cache/huggingface
export HF_DATASETS_CACHE=$REAL_PWD/.cache/huggingface/datasets
export TRITON_CACHE_DIR=$REAL_PWD/.cache/triton

export CUDA_VISIBLE_DEVICES=0,1,2,3
export MPICH_GPU_SUPPORT_ENABLED=1
export NCCL_SOCKET_IFNAME=hsn0,hsn1,hsn2,hsn3
export OMP_NUM_THREADS=1
export CUDA_DEVICE_MAX_CONNECTIONS=1

CMD="
source /opt/miniconda3/bin/activate pytorch
torchrun --nproc_per_node=4 run_train.py --config-file examples/config_tiny_llama.yaml
"

srun -A project_462000558 -p dev-g --gpus-per-node=mi250:4 -N 1 --mem 100gb --cpus-per-task 8 --time 1:00:00 --pty \
singularity exec --pwd "$REAL_PWD" "$CONTAINER" bash -c "$CMD"

