import os
import turicreate as tc

# Configure as required
output_model_filename = 'DrawingClassifierModel'
this_directory = os.path.dirname(os.path.realpath(__file__))
bitmap_sframe_path = this_directory + '/quickdraw/bitmap/bitmaps.sframe'
strokes_sframe_path = this_directory + '/quickdraw/strokes/strokes.sframe'

# Load the data
bitmap_data =  tc.load_sframe(bitmap_sframe_path)
strokes_data =  tc.load_sframe(strokes_sframe_path)

# Create a model
# (in a production model you would do a training/testing data split)
# (but we don't mind how inaccurate it is for a demonstration)
bitmap_model = tc.drawing_classifier.create(bitmap_data, 'label')
strokes_model = tc.drawing_classifier.create(strokes_data, 'label')

# Export for use in Core ML
bitmap_model.export_coreml(output_model_filename + 'Bitmap.mlmodel')
sterokes_model.export_coreml(output_model_filename + 'Strokes.mlmodel')
