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
# Script to download and preprocess the PASCAL VOC 2012 dataset.
#
# Usage:
#   bash ./download_and_convert_voc2012.sh
#
# The folder structure is assumed to be:
#  + datasets
#     - build_data.py
#     - build_voc2012_data.py
#     - download_and_convert_voc2012.sh
#     - remove_gt_colormap.py
#     + pascal_voc_seg
#       + VOCdevkit
#         + VOC2012
#           + JPEGImages
#           + SegmentationClass
#

# Exit immediately if a command exits with a non-zero status.
set -e

CURRENT_DIR=$(pwd)
WORK_DIR="./mvd_water"

cd "${CURRENT_DIR}"

# Root path for MV dataset.
MVD_WATER_ROOT="${WORK_DIR}"
MVD_SIMP_ROOT="./mvd_simplified"
MVD_ROOT="./mvd"

# Remove the colormap in the ground truth annotations.
# SEG_FOLDER="${MVD_SIMP_ROOT}/SegmentationClass"
SEMANTIC_SEG_FOLDER="${MVD_SIMP_ROOT}/SegmentationClassRaw"

#echo "Removing the color map in ground truth annotations..."
#python ./remove_gt_colormap.py \
#  --original_gt_folder="${SEG_FOLDER}" \
#  --output_dir="${SEMANTIC_SEG_FOLDER}"

# Build TFRecords of the dataset.
# First, create output directory for storing TFRecords.
OUTPUT_DIR="${WORK_DIR}/tfrecord"
mkdir -p "${OUTPUT_DIR}"

IMAGE_FOLDER="${MVD_ROOT}/images"
LIST_FOLDER="${MVD_WATER_ROOT}/index"

# Resize images for evaluation 
RESIZE_IMG_Folder="${MVD_WATER_ROOT}/ResizedImages/images"
RESIZE_LABEL_Folder="${MVD_WATER_ROOT}/ResizedImages/SegmentationClassRaw"
mkdir -p "${RESIZE_IMG_Folder}"
mkdir -p "${RESIZE_LABEL_Folder}"

echo "Converting MV dataset..."
python ./build_mvd_data.py \
  --image_folder="${IMAGE_FOLDER}" \
  --resized_image_folder="${RESIZE_IMG_Folder}" \
  --semantic_segmentation_folder="${SEMANTIC_SEG_FOLDER}" \
  --resized_label_folder="${RESIZE_LABEL_Folder}" \
  --list_folder="${LIST_FOLDER}" \
  --image_format="jpg" \
  --output_dir="${OUTPUT_DIR}" \
  --eval_max_width=4032 \
  --eval_max_height=3024 \
