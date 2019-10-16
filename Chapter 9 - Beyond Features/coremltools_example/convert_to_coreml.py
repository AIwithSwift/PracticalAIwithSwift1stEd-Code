# BEGIN coremltools_example_import
import coremltools
# END coremltools_example_import

# define a convert from caffee
# BEGIN coremltools_example_convert
coreml_model = coremltools.converters.caffe.convert(
    (
        'twitter_finetuned_test4_iter_180.caffemodel', 
        'sentiment_deploy.prototxt'
    ), 
    image_input_names = 'data', 
    class_labels='class_labels.txt'
)
# END coremltools_example_convert

# BEGIN coremltools_example_outputs
coreml_model.output_description['prob'] = (
    'Probability for a certain sentiment.'
)
coreml_model.output_description['classLabel'] = 'Most likely sentiment.'
# END coremltools_example_outputs

# BEGIN coremltools_example_metadata
coreml_model.author = (
    'Practical AI with Swift Reader based on work of Image ' + 
        'Processing Group'
)
coreml_model.license = 'MIT'
coreml_model.short_description = (
    'Fine-tuning CNNs for Visual Sentiment Prediction'
)
coreml_model.input_description['data'] = 'Image'
# END coremltools_example_metadata

# BEGIN coremltools_example_save
coreml_model.save('VisualSentiment.mlmodel')
# END coremltools_example_save
