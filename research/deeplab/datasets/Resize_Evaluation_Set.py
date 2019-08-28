# -*- coding: utf-8 -*-
"""
Created on Wed Mar 27 09:54:04 2019

This code is used to crop high resolution evaluation images into 512 X 512 smaller
images

@author: Yawen Shen
"""
from PIL import Image
import os.path

class ImageResizer(object):
  """Helper class that resize mvd elevation images"""
  
  def __init__(self, width, height, img_folder, img_name, img_format, img_out_folder):
      self.width = width
      self.height = height
      self.img_folder = img_folder
      self.img_name = img_name
      self.img_format = img_format
      self.img_out_folder = img_out_folder
      
  def resize_img(self):
      im = Image.open(os.path.join(self.img_folder, self.img_name + "."+ self.img_format))
      imgwidth, imgheight = im.size
      resized_img = os.path.join(self.img_out_folder, self.img_name + "."+ self.img_format)
      if imgwidth<=self.width and imgheight<=self.height:
          im.save(resized_img)
      else:
          new_img = im.resize((self.width, self.height))
          new_img.save(resized_img)
      
      return resized_img