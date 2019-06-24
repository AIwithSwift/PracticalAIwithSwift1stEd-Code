import requests
import os

# THE CATEGORIES WE WANT TO BE ABLE TO DISTINGUISH
categories = [
    'apple', 'banana', 'bread', 'broccoli', 'cake', 'carrot', 'coffee cup', 'cookie',
    'donut', 'grapes', 'hot dog', 'ice cream', 'lollipop', 'mushroom', 'peanut', 'pear',
    'pineapple', 'pizza', 'potato', 'sandwich', 'steak', 'strawberry', 'watermelon'
]


# MAKE SOME FOLDERS TO PUT TRAINING DATA IN
def make_directory(path):
	try:
		os.makedirs(path)
	except OSError:
		if not os.path.isdir(path):
			raise

this_directory = os.path.dirname(os.path.realpath(__file__))
quickdraw_directory = this_directory + '/quickdraw'
bitmap_directory = quickdraw_directory + '/bitmap'
strokes_directory = quickdraw_directory + '/strokes'

make_directory(quickdraw_directory)
make_directory(bitmap_directory)
make_directory(strokes_directory)


# FETCH SOME DATA
bitmap_url = 'https://storage.googleapis.com/quickdraw_dataset/full/numpy_bitmap'
strokes_url = 'https://storage.googleapis.com/quickdraw_dataset/full/raw'
total_categories = len(categories)

for index, category in enumerate(categories):
	bitmap_filename = '/' + category + '.npy'
	strokes_filename = '/' + category + '.ndjson'

	with open(bitmap_directory + bitmap_filename, 'w+') as bitmap_file:
		bitmap_response = requests.get(bitmap_url + bitmap_filename)
		bitmap_file.write(bitmap_response.content)

	with open(strokes_directory + strokes_filename, 'w+') as strokes_file:
		strokes_response = requests.get(strokes_url + strokes_filename)
		strokes_file.write(strokes_response.content)

	print('Downloaded %s drawings (category %d/%d)' % (category, index + 1, total_categories))
