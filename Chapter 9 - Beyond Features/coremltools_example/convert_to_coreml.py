# import coremltools
import coremltools

# define a convert from caffee
coreml_model = coremltools.converters.caffe.convert(('twitter_finetuned_test4_iter_180.caffemodel', 'sentiment_deploy.prototxt'), image_input_names = 'data', class_labels='class_labels.txt')

coreml_model.output_description['prob'] = 'Probability for a certain sentiment.'
coreml_model.output_description['classLabel'] = 'Most likely sentiment.'

coreml_model.author = 'Practical AI with Swift Reader based on work of Image Processing Group'
coreml_model.license = 'MIT'
coreml_model.short_description = 'Fine-tuning CNNs for Visual Sentiment Prediction'
coreml_model.input_description['data'] = 'Image'

coreml_model.save('VisualSentiment.mlmodel')