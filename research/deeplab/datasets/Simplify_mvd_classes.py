# -*- coding: utf-8 -*-
"""
Simplify mvd for flood image identifying
unlabel several nonimportant labels
combined several classes

@author: YawenShen
"""

from PIL import Image
import os
import pandas as pd
import numpy as np

class class_simplifyer(object):
    def __init__(self, class_index, label_folder, label_out_folder):
      self.class_index = class_index
      self.label_folder = label_folder
      self.label_out_folder = label_out_folder
      
    def simplify_img(self):
        class_df = pd.read_csv(self.class_index)
        labels_im = os.listdir(self.label_folder)
        
        n = 0
        for image in labels_im:
            n += 1
            print("Image: " + str(n))
            
            im = Image.open(os.path.join(self.label_folder, image))
            pixels = np.asarray(im)
            
            for index, row in class_df.iterrows():
                old_id = int(row['old_class_id'])
                new_id = int(row['new_class_id'])
                pixels = np.where(pixels==old_id, new_id, pixels)
            
            new_im = Image.fromarray(pixels)
            new_im.save(os.path.join(self.label_out_folder, image))

path = 'C:/models-master/research/deeplab/datasets/'
img_simp = class_simplifyer(path + 'mvd_simplified/Final_old_class_to_new_class_id.csv',
                            path + 'mvd_simplified/SegmentationClassRaw_old', path + 'mvd_simplified/SegmentationClassRaw')
img_simp.simplify_img()
