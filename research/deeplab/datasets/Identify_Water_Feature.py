from PIL import Image

path = "C:/models-master/research/deeplab/datasets"
dataset = "mvd"

def findwater(images_list, output):
    n=1
    for img_name in images_list:
        img_name = img_name.rstrip()
        print(n)
        n += 1
        im = Image.open(path + "/" + dataset + "/SegmentationClass/"+img_name+".png")
        pixels = im.load()
        
        for i in range(im.size[0]): # for every pixel:
            temp = 0
            for j in range(im.size[1]):
                if pixels[i,j] == 31:
                    print("Water: " + img_name)
                    file = open(output, "a")
                    file.write(img_name+ "\n")
                    file.close
                    temp=1
                    break
            if temp==1:
                break
    

images_list = open(path + "/" + dataset + "/index/" + "train.txt", "r")
output = path + "/" + dataset + "/" + "water_trainset.txt"
print("Training Set:\n")
findwater(images_list, output)
images_list.close()

images_list = open(path + "/" + dataset + "/index/" + "val.txt", "r")
output = path + "/" + dataset + "/" + "water_valset.txt"
print("Val Set:\n")
findwater(images_list, output)
images_list.close()