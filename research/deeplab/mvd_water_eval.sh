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
MVD_SIMPLIFIED_FOLDER="mvd_simplified"
MVD_WATER_FOLDER="mvd_water"
##############################################################################################
EXP_FOLDER="exp/train_set_MVD_WATER_batch8_iter10k_init_Cityscapes_WW1.0"
##############################################################################################
INIT_FOLDER="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/init_models"
# PRETRAIN_FOLDER="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/exp/train_set_MVD_batch6_iter20000"
TRAIN_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_WATER_FOLDER}/${EXP_FOLDER}/train"
EVAL_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_WATER_FOLDER}/${EXP_FOLDER}/eval"
VIS_LOGDIR="${WORK_DIR}/${DATASET_DIR}/${MVD_WATER_FOLDER}/${EXP_FOLDER}/vis"
EXPORT_DIR="${WORK_DIR}/${DATASET_DIR}/${MVD_WATER_FOLDER}/${EXP_FOLDER}/export"
mkdir -p "${INIT_FOLDER}"
mkdir -p "${TRAIN_LOGDIR}"
mkdir -p "${EVAL_LOGDIR}"
mkdir -p "${VIS_LOGDIR}"
mkdir -p "${EXPORT_DIR}"

cd "${CURRENT_DIR}"

MVD_WATER_DATASET="${WORK_DIR}/${DATASET_DIR}/${MVD_WATER_FOLDER}/tfrecord"
  

#### Run evaluation. This performs eval over the full val split (33 images) and
#### will take a while.
#### Using the provided checkpoint, one should expect mIOU=82.20%.
# python "${WORK_DIR}"/eval.py \
  # --logtostderr \
  # --eval_split="val" \
  # --model_variant="xception_65" \
  # --atrous_rates=6 \
  # --atrous_rates=12 \
  # --atrous_rates=18 \
  # --output_stride=16 \
  # --decoder_output_stride=4 \
  # --eval_crop_size='3025,4033' \
  # --dataset="mvd" \
  # --checkpoint_dir="${TRAIN_LOGDIR}" \
  # --eval_logdir="${EVAL_LOGDIR}" \
  # --dataset_dir="${MVD_DATASET}" \
  # --max_number_of_evaluations=1
  
python "${WORK_DIR}"/eval_each_class.py \
  --logtostderr \
  --eval_split="val" \
  --model_variant="xception_65" \
  --atrous_rates=6 \
  --atrous_rates=12 \
  --atrous_rates=18 \
  --output_stride=16 \
  --decoder_output_stride=4 \
  --eval_crop_size='3025,4033' \
  --dataset="mvd_water" \
  --checkpoint_dir="${TRAIN_LOGDIR}" \
  --eval_logdir="${EVAL_LOGDIR}" \
  --dataset_dir="${MVD_WATER_DATASET}" \
  --max_number_of_evaluations=1

