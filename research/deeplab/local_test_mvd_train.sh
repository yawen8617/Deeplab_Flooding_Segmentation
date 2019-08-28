#!/bin/bash
# Copyright 2018 The TensorFlow Authors All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
#
#
# Usage:
#   # From the tensorflow/models/research/deeplab directory.
#   sh ./local_test_mvd.sh
#
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Move one-level up to tensorflow/models/research directory.
cd ..

# Update PYTHONPATH.
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

# Set up the working environment.
CURRENT_DIR=$(pwd)
WORK_DIR="${CURRENT_DIR}/deeplab"

# datasets folder
DATASET_DIR="datasets"

# Go back to original directory.
cd "${CURRENT_DIR}"

# Set up the working directories.
MVD_FOLDER="mvd"
##############################################################################################
EXP_FOLDER="exp/train_set_MVD_batch8_iter10k"
##############################################################################################
INIT_FOLDER="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/init_models"
# PRETRAIN_FOLDER="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/exp/train_set_MVD_batch6_iter20000"
TRAIN_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/${EXP_FOLDER}/train"
EVAL_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/${EXP_FOLDER}/eval"
VIS_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/${EXP_FOLDER}/vis"
EXPORT_DIR="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/${EXP_FOLDER}/export"
mkdir -p "${INIT_FOLDER}"
mkdir -p "${TRAIN_LOGDIR}"
mkdir -p "${EVAL_LOGDIR}"
mkdir -p "${VIS_LOGDIR}"
mkdir -p "${EXPORT_DIR}"

cd "${CURRENT_DIR}"

MVD_DATASET="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/tfrecord"
  
  ### Train 10000 iterations.
NUM_ITERATIONS=20000
python "${WORK_DIR}"/train.py \
  --logtostderr \
  --num_clones=2 \
  --train_split="train" \
  --model_variant="xception_65" \
  --atrous_rates=6 \
  --atrous_rates=12 \
  --atrous_rates=18 \
  --output_stride=16 \
  --decoder_output_stride=4 \
  --train_crop_size="513,513" \
  --train_batch_size=8 \
  --base_learning_rate=0.004 \
  --learning_rate_decay_step=200 \
  --weight_decay=0.000005 \
  --training_number_of_steps="${NUM_ITERATIONS}" \
  --log_steps=1 \
  --save_summaries_secs=60 \
  --tf_initial_checkpoint="${INIT_FOLDER}/deeplabv3_cityscapes_train/model.ckpt" \
  --initialize_last_layer=true \
  --train_logdir="${TRAIN_LOGDIR}" \
  --dataset_dir="${MVD_DATASET}"
  
# # Train from pretrained model, reuse all trained-weights
# NUM_ITERATIONS=20000
# python "${WORK_DIR}"/train.py \
  # --logtostderr \
  # --num_clones=2 \
  # --train_split="train" \
  # --model_variant="xception_65" \
  # --atrous_rates=6 \
  # --atrous_rates=12 \
  # --atrous_rates=18 \
  # --output_stride=16 \
  # --decoder_output_stride=4 \
  # --train_crop_size="513,513" \
  # --train_batch_size=6 \
  # --base_learning_rate=0.004 \
  # --learning_rate_decay_step=200 \
  # --weight_decay=0.00001 \
  # --training_number_of_steps="${NUM_ITERATIONS}" \
  # --log_steps=1 \
  # --save_summaries_secs=60 \
  # --tf_initial_checkpoint="${PRETRAIN_FOLDER}/train/model.ckpt-20000" \
  # --initialize_last_layer=true \
  # --last_layers_contain_logits_only=false \
  # --train_logdir="${TRAIN_LOGDIR}" \
  # --dataset_dir="${MVD_DATASET}"
  
  
