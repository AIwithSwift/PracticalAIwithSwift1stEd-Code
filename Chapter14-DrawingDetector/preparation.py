import os
import json
import numpy as np
import turicreate as tc

categories = [
    'apple', 'banana', 'bread', 'broccoli', 'cake', 'carrot', 'coffee cup', 'cookie',
    'donut', 'grapes', 'hot dog', 'ice cream', 'lollipop', 'mushroom', 'peanut', 'pear',
    'pineapple', 'pizza', 'potato', 'sandwich', 'steak', 'strawberry', 'watermelon'
]

# Configure as required
this_directory = os.path.dirname(os.path.realpath(__file__))
bitmap_directory = this_directory + '/quickdraw/bitmap/'
strokes_directory = this_directory + '/quickdraw/strokes/'
bitmap_sframe_path = bitmap_directory + 'bitmaps.sframe'
strokes_sframe_path = strokes_directory + 'strokes.sframe'
samples = 100

random_state = np.random.RandomState(100)



def make_image(pixel_data):
    return tc.Image(_image_data = pixel_data.tobytes(),
        _width = pixel_data.shape[1],
        _height = pixel_data.shape[0],
        _channels = pixel_data.shape[2],
        _format_enum = 2,
        _image_data_size = pixel_data.size)

def make_strokes(drawing_data):
    for stroke in drawing_data:
        for index, point in enumerate(stroke[0]):
            return { 'x': point, 'y': stroke[1][index] }

def get_bitmap_sframe():
    labels, drawings = [], []
    for category in categories:
        data = np.load(bitmap_directory + category + '.npy')
        random_state.shuffle(data)
        sampled_data = data[:samples]
        transformed_data = data.reshape(data.shape[0], 28, 28, 1)
        for pixel_data in transformed_data:
        	drawings.append(make_image(pixel_data))
        	labels.append(category)
        print('...%s bitmaps complete' % category)
    print('%d bitmaps with %d labels' % (len(drawings), len(labels)))
    return tc.SFrame({'drawing': drawings, 'label': labels})

def get_strokes_sframe():
    labels, drawings = [], []
    for category in categories:
        file = open(strokes_directory + category + '.ndjson')
        data = list(map(lambda x: x.strip(), file.readlines()))
        file.close()
        random_state.shuffle(data)
        sampled_data = data[:samples]
        transformed_data = [object['drawing'] for object in list(map(json.loads, data))]
        for drawing_data in transformed_data:
        	drawings.append(make_strokes(drawing_data))
        	labels.append(category)
        print('...%s strokes complete' % category)
    print('%d stroke sets with %d labels' % (len(drawings), len(labels)))
    return tc.SFrame({'drawing': drawings, 'label': labels})


# Save intermediate bitmap SFrame to file
bitmap_sframe = get_bitmap_sframe()
bitmap_sframe.save(bitmap_sframe_path)

# Save intermediate strokes SFrame to file
strokes_sframe = get_strokes_sframe()
strokes_sframe.save(strokes_sframe_path)

