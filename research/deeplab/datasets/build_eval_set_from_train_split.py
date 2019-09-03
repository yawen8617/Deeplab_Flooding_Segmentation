# -*- coding: utf-8 -*-
"""
Randomly extract certain number of images from training dataset to compute
the accuracy on training dataset

The selected images have a resolution lower than a threshold 
for mvd: [3024, 4032]

@author: YawenShen
"""

import numpy as np
import os
from PIL import Image
import random

def build_image_sets(num_images, source_dir, Index_dir):
    images_filename_list = []
    eval_in_train_list = []
    filenames = [x.strip('\n') for x in open(os.path.join(Index_dir, 'train.txt'), 'r')]
    
    for im_name in filenames:
        im = Image.open(os.path.join(source_dir, im_name + '.jpg'))
        width, height = im.size
        
        if width < 4032 and height < 3024:
         	images_filename_list.append(im_name)
    
    print("Total number of images smaller then [3024, 4032]: " + str(len(images_filename_list)))
    
    if len(images_filename_list) <= num_images:
        print("Number of selected images smaller than desired number")
        eval_in_train_list = images_filename_list
    else:
        eval_in_train_list = random.sample(images_filename_list, num_images)
    
    with open(os.path.join(Index_dir, 'eval_in_train.txt'), "w") as f:
        for filename in eval_in_train_list:
            f.write((filename) + "\n")
    
    print("Finished")
    print("List stored in " + os.path.join(Index_dir, 'eval_in_train.txt'))

if __name__ == '__main__':
    num_images = 2000
    source_dir = 'C:/models-master/research/deeplab/datasets/mvd/images/'
    Index_dir = 'C:/models-master/research/deeplab/datasets/mvd_simplified/index/'
    build_image_sets(num_images, source_dir, Index_dir)

