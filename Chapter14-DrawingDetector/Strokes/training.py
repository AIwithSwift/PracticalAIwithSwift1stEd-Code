import os
import json
import requests
import numpy as np
import turicreate as tc

# THE CATEGORIES WE WANT TO BE ABLE TO DISTINGUISH
categories = [
    'apple', 'banana', 'bread', 'broccoli', 'cake', 'carrot', 'coffee cup', 'cookie',
    'donut', 'grapes', 'hot dog', 'ice cream', 'lollipop', 'mushroom', 'peanut', 'pear',
    'pineapple', 'pizza', 'potato', 'sandwich', 'steak', 'strawberry', 'watermelon'
]

# CONFIGURE AS REQUIRED
this_directory = os.path.dirname(os.path.realpath(__file__))
quickdraw_directory = this_directory + '/quickdraw'
strokes_directory = quickdraw_directory + '/strokes'
strokes_sframe_path = quickdraw_directory + '/strokes.sframe'
output_model_filename = 'DrawingClassifierModel'
training_samples = 100

# MAKE SOME FOLDERS TO PUT TRAINING DATA IN
def make_directory(path):
	try:
		os.makedirs(path)
	except OSError:
		if not os.path.isdir(path):
			raise

make_directory(quickdraw_directory)
make_directory(strokes_directory)

# FETCH SOME DATA
strokes_url = 'https://storage.googleapis.com/quickdraw_dataset/full/raw'
total_categories = len(categories)

for index, category in enumerate(categories):
	bitmap_filename = '/' + category + '.npy'

	with open(strokes_directory + strokes_filename, 'w+') as strokes_file:
		strokes_response = requests.get(strokes_url + strokes_filename)
		strokes_file.write(strokes_response.content)

	print('Downloaded %s drawings (category %d/%d)' % (category, index + 1, total_categories))

random_state = np.random.RandomState(100)

def make_strokes(drawing_data):
    strokes = []
    for stroke in drawing_data:
        for index, point in enumerate(stroke[0]):
            strokes.append({ 'x': point, 'y': stroke[1][index] })
    return strokes

def get_strokes_sframe():
    labels, drawings = [], []
    for category in categories:
        file = open(strokes_directory + '/' + category + '.ndjson')
        data = list(map(lambda x: x.strip(), file.readlines()))
        file.close()
        random_state.shuffle(data)
        sampled_data = data[:training_samples]
        transformed_data = [object['drawing'] for object in list(map(json.loads, sampled_data))]
        for drawing_data in transformed_data:
            drawings.append(make_strokes(drawing_data))
            labels.append(category)
        print('...%s strokes complete' % category)
    print('%d stroke sets with %d labels' % (len(drawings), len(labels)))
    return tc.SFrame({'drawing': drawings, 'label': labels})

# Save intermediate strokes SFrame to file
strokes_sframe = get_strokes_sframe()
strokes_sframe.save(strokes_sframe_path)

# STROKES MODEL

# Load the data
strokes_data =  tc.load_sframe(strokes_sframe_path)

# Create a model
# (in a production model you would do a training/testing data split)
# (but we don't mind how inaccurate it is for a demonstration)
strokes_model = tc.drawing_classifier.create(strokes_data, 'label')

# Export for use in Core ML
strokes_model.export_coreml(output_model_filename + 'Strokes.mlmodel')

