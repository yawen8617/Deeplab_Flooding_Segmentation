from PIL import Image
import random
import os
import pandas as pd
import numpy as np

path = "C:/models-master/research/deeplab/datasets"
dataset = "mvd"

def class_weight_dist(image_path):
    # create dataframe to store weight
    classes = list(range(0, 66))
    columns = ['pixels']
    weight_df = pd.DataFrame(index=classes, columns=columns)
    weight_df = weight_df.fillna(0)
    
    selected_images = random.sample(os.listdir(image_path), 2000)
    n = 0
    for image in selected_images:
        n += 1
        print("Image: " + str(n))
        
        im = Image.open(os.path.join(image_path, image))
        pixels = list(im.getdata())
        unique_class, counts = np.unique(pixels, return_counts=True)
        temp_df = pd.DataFrame(counts, index=unique_class, columns=columns)
        weight_df = weight_df.add(temp_df, fill_value=0)
    
    Total_pixels = float(weight_df['pixels'].sum())
    fn = lambda row: row.pixels/Total_pixels
    col = weight_df.apply(fn, axis=1)
    weight_df = weight_df.assign(weight=col.values)
    
    return weight_df
    

for i in range(1,5):
    weight = class_weight_dist(os.path.join(path, dataset, "SegmentationClassRaw"))
    weight.to_csv(os.path.join(path, dataset, "class_weight_" + str(i) + ".csv"))