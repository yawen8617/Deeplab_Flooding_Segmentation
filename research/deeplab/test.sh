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
EXP_FOLDER="exp/train_set_MVD_init_model_cityscapes_10000ites_batch6"
##############################################################################################
INIT_FOLDER="${WORK_DIR}/${DATASET_DIR}/${MVD_FOLDER}/init_models"
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
python deeplab/train.py \
    --logtostderr \
    --training_number_of_steps=300 \
    --train_split="train" \
    --model_variant="xception_65" \
    --atrous_rates=6 \
    --atrous_rates=12 \
    --atrous_rates=18 \
    --output_stride=16 \
    --decoder_output_stride=4 \
    --train_crop_size=513 \
    --train_crop_size=513 \
    --train_batch_size=2 \
    --dataset="mvd" \
    --tf_initial_checkpoint='C:/Users/YawenShen/Desktop/models-master/models-master/research/deeplab/datasets/mvd/init_models/deeplabv3_cityscapes_train/model.ckpt' \
    --train_logdir='C:/Users/YawenShen/Desktop/models-master/models-master/research/deeplab/datasets/mvd/exp/train_set_MVD_init_model_cityscapes_10000ites_batch6/train' \
    --dataset_dir='C:/Users/YawenShen/Desktop/models-master/models-master/research/deeplab/datasets/mvd/tfrecord'
