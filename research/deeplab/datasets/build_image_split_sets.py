import numpy as np
import os
from shutil import copyfile
from PIL import Image


def build_image_sets(val_ratio=0.1):
    max_height = 0
    max_width = 0
    source_dir = 'C:/Users/YawenShen/Desktop/models-master/models-master/research/deeplab/datasets/mvd/images/'
    Index_dir = 'C:/Users/YawenShen/Desktop/models-master/models-master/research/deeplab/datasets/mvd/index/'
    source_filename_list = os.listdir(source_dir)
    images_filename_list = []
    i = 1
    print("Number of Images:")
    print(len(source_filename_list))
    for filename in source_filename_list:
        print(i)
        i += 1
        if os.path.splitext(filename)[0] == '.DS_Store':
            continue
        im = Image.open(source_dir + os.path.splitext(filename)[0] + '.jpg')
        width, height = im.size
        # if width < 3264 and height < 3264:

        # Yawen: original code, why only select this size range?
        if width < 10000 and height < 10000:
         	if height > max_height:
         		max_height = height
         	if width > max_width:
         		max_width = width
         	images_filename_list.append(os.path.splitext(filename)[0])

        # Yawen: Modified Code
#        if height > max_height:
#            max_height = height
#        if width > max_width:
#            max_width = width
#        images_filename_list.append(os.path.splitext(filename)[0])
            # src = source_dir + os.path.splitext(filename)[0] + '.jpg'
            # dst = '/Users/shengli/Desktop/models/research/deeplab/datasets/mvd/mvd_raw/JPEGImages/' \
            # 	+ os.path.splitext(filename)[0] + '.jpg'
            # copyfile(src, dst)

        # images_dir = '/home/shengli/models/research/deeplab/datasets/mvd/mvd_raw/JPEGImages/'
        # images_filename_list = os.listdir(images_dir)

    # for filename in images_filename_list:
    # 	if os.path.splitext(filename)[0] == '.DS_Store':
    # 		continue
    # 	src = '/Users/shengli/Downloads/mapillary-vistas-dataset_public_v1.0/training/labels/' \
    # 		+ os.path.splitext(filename)[0] + '.png'
    # 	dst = '/Users/shengli/Desktop/models/research/deeplab/datasets/mvd/mvd_raw/SegmentationClass/' \
    # 		+ os.path.splitext(filename)[0] + '.png'
    # 	copyfile(src, dst)

    np.random.shuffle(images_filename_list)
    print(len(images_filename_list))

    # split 10% val, 90% train
    val_images_filename_list = images_filename_list[:int(val_ratio * len(images_filename_list))]
    train_images_filename_list = images_filename_list[int(val_ratio * len(images_filename_list)):]

    num_train = 0
    num_val = 0

    with open(Index_dir + 'train.txt', "w") as f:
        for filename in train_images_filename_list:
            if os.path.splitext(filename)[0] == '.DS_Store':
                continue
            f.write(os.path.splitext(filename)[0] + "\n")
            num_train += 1

    with open(Index_dir + 'val.txt', "w") as f:
        for filename in val_images_filename_list:
            if os.path.splitext(filename)[0] == '.DS_Store':
                continue
            f.write(os.path.splitext(filename)[0] + "\n")
            num_val += 1

    filenames = [Index_dir + 'train.txt', Index_dir + 'val.txt']
    with open(Index_dir + 'trainval.txt', 'w') as outfile:
        for fname in filenames:
            with open(fname) as infile:
                outfile.write(infile.read())

    print('Max dims of MVD is h = {}, w = {}'.format(max_height, max_width))
    print('num_train = {}'.format(num_train))
    print('num_val = {}'.format(num_val))
    print('num_trainval = {}'.format(num_train + num_val))


build_image_sets(val_ratio=0.1)
