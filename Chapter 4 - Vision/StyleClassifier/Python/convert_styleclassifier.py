import coremltools

coreml_model = coremltools.converters.caffe.convert(('./finetune_flickr_style.caffemodel', './deploy.prototxt'), image_input_names = 'data', class_labels = './styles.txt')
coreml_model.author = 'Paris BA'
coreml_model.license = 'None'
coreml_model.short_description = 'Flickr Style'
coreml_model.input_description['data'] = 'An image.'
coreml_model.output_description['prob'] = 'Probabilities for style type, for a given input.'
coreml_model.output_description['classLabel'] = 'The most likely style type for the given input.'
coreml_model.save('Style.mlmodel')
