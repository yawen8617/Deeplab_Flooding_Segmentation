# -*- coding: utf-8 -*-
"""
Extract Evaluation results from Tensorboard log

@author: YawenShen
"""



import os
import numpy as np
import pandas as pd
import glob

from collections import defaultdict
from tensorboard.backend.event_processing.event_accumulator import EventAccumulator


def tabulate_events(event):    
    data = {}
    event_acc = EventAccumulator(event)
    event_acc.Reload()
        
    for tag in sorted(event_acc.Tags()["scalars"]):
        x = []
        for scalar_event in event_acc.Scalars(tag):
            x.append(scalar_event.value)
        data[tag] = (np.array(x))    
    return data

def to_csv(dpath, class_num, iterations):
    class_id = []
    for i in range(class_num):
        class_id.append('class_' + str(i) + '_iou')
    output_df = pd.DataFrame(index=class_id)
    
    
    
    events = glob.glob(os.path.join(dpath, "events.out.tfevents*"))
    for event in events:
        event_id = os.path.basename(event).split('.')[3]
        
        columns = []
        for ite in iterations:
            columns.append(event_id + '_ite' + str(ite))
        
        iou = tabulate_events(event)
        iou_df = pd.DataFrame.from_dict(iou, orient='index', columns=columns)
        output_df = output_df.join(iou_df)
    print(output_df)
    output_df.to_csv(os.path.join(dpath, 'IOU_Summary.csv'))
        
