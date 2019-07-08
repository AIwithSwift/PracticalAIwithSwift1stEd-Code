from coremltools.converters.keras import convert
from keras.models import model_from_json

generator_model = None
with open('generator.json', 'r') as f:
    generator_model = model_from_json(f.read())

print('Model loaded...')

generator_model.load_weights('generator.h5')

print('Weights transferred...')

coreml_model = convert(generator_model)
coreml_model.save('MnistGan.mlmodel')

print('Complete.')

# then go compile it on the command linem with
# $ xcrun coremlcompiler compile MnistGan.mlmodel MnistGan.mlmodelc
