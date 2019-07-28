########################################################################
#    CONFIGURE AS REQUIRED
########################################################################
import random
import numpy as np
import tensorflow as tf

# seed random
def reset_seed():
    random.seed(3)
    np.random.seed(1)
    tf.set_random_seed(2)

# gan parameters
GAN_EPOCHS = 60 # how many epochs to train GAN for
BATCH_SIZE = 128 # how many images to consider at once
CHECKPOINT = 10 # how often (in epochs) to save sample GAN output

# must match OUTPUT_DIRECTORY in harness
import os
OUTPUT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))

########################################################################
#    ENVIRONMENT SETUP
########################################################################
import matplotlib.pyplot as plt
import pandas as pd
from keras import utils
from keras.datasets import mnist
from keras.layers import *
from keras.models import *
from keras.optimizers import *
from coremltools.converters.keras import convert

import os
os.environ['KMP_DUPLICATE_LIB_OK']='True'
# ^^ no idea what this does but a GitHub issues thread says it
# would solve the environment crash I had, and it did :/

# make tensorflow stop complaining I could get better performance if I
# configured parallelism parameters manually (by doing so, kind of)
config = tf.ConfigProto(intra_op_parallelism_threads=0,
                        inter_op_parallelism_threads=0,
                        allow_soft_placement=True)
session = tf.Session(config=config)

########################################################################
#    DATA SETUP
########################################################################
def setup_data():
    # get mnist data
    (x_train, y_train), (x_test, y_test) = mnist.load_data()
    x_full = np.concatenate((x_train, x_test))
    y_full = np.concatenate((y_train, y_test))

    images = [None] * 10
    counts = {}

    # for each data point in input
    for i in range(len(x_full)):
        class_label = y_full[i]

        # put the image in the right array
        class_data = images[class_label] if images[class_label] is not None else []
        image = x_full[i]
        class_data.append(image)
        images[class_label] = class_data

    images = [np.array(class_images) for class_images in images]
    return np.array(images)

########################################################################
#    SET OPTIMIZER FOR ALL MODEL COMPILATIONS
########################################################################
def get_optimizer():
    return SGD(lr=0.0005, momentum=0.9, nesterov=True)

########################################################################
#    TRANSFORM DATA FOR MODEL INPUT
########################################################################
def preprocess_images(images):
    images = images.reshape(images.shape[0], 28, 28, 1) # add a new axis
    # so each final-level element is instead a one-element array
    images = images.astype(np.float32) # convert to half-precision
    images = (images - 127.5) / 127.5 # normalize grayscale values
    # to either pure black OR pure white
    return images

########################################################################
#    DISCRIMINATOR MODEL COMPONENT OF GAN
########################################################################
def get_discriminator():
    input_x = Input(shape=(28, 28, 1))
    x = input_x

    x = Conv2D(64, kernel_size=(5, 5), padding='same', activation='tanh')(x)
    x = MaxPooling2D(pool_size=(2, 2))(x)

    x = Conv2D(128, kernel_size=(5, 5), activation='tanh')(x)
    x = MaxPooling2D(pool_size=(2, 2))(x)

    x = Flatten()(x)
    x = Dense(1024, activation='tanh')(x)
    x = Dense(1, activation='sigmoid')(x)

    return Model(inputs=input_x, outputs=x)

########################################################################
#    GENERATOR MODEL COMPONENT OF GAN
########################################################################
def get_generator(z_dim=100):
    input_x = Input(shape=(z_dim,))
    x = input_x

    x = Dense(1024, activation='tanh')(x)
    x = Dense(128 * 7 * 7, activation='tanh')(x)
    x = BatchNormalization()(x)
    x = Reshape((7, 7, 128))(x)

    x = UpSampling2D(size=(2, 2))(x)
    x = Conv2D(64, kernel_size=(5, 5), padding='same', activation='tanh')(x)

    x = UpSampling2D(size=(2, 2))(x)
    x = Conv2D(1, kernel_size=(5, 5), padding='same', activation='tanh')(x)

    return Model(inputs=input_x, outputs=x)

########################################################################
#    DISCRIMINATOR MODEL MUST BE FROZEN AT CERTAIN POINTS
########################################################################
def make_trainable(model, setting):
    model.trainable = setting
    for layer in model.layers:
        layer.trainable = setting

########################################################################
#    GENERATE RANDOM INPUT NOISE
########################################################################
def generate_noise(n_samples, z_dim=100):
    random_numbers = np.random.normal(-1., 1., size=(n_samples, z_dim))
    return random_numbers.astype(np.float32)

########################################################################
#    GET RANDOM SAMPLING OF REAL DATA
########################################################################
def get_real_input(x_train, n_samples):
    real_images = random.choices(x_train, k=n_samples)
    real_labels = np.ones((n_samples, 1))
    return real_images, real_labels

########################################################################
#    GET RANDOM ASSORTMENT OF FAKE DATA
########################################################################
def get_fake_input(generator, n_samples):
    latent_input = generate_noise(n_samples)
    generated_images = generator.predict(latent_input)
    fake_labels = np.zeros((n_samples, 1))
    return generated_images, fake_labels

########################################################################
#    GET RANDOM ASSORTMENT OF NOISE DATA
########################################################################
def get_gan_input(n_samples):
    latent_input = generate_noise(n_samples)
    inverted_labels = np.ones((n_samples, 1))
    return latent_input, inverted_labels

########################################################################
#    PLOT HOW THE MODEL IS DOING AT CERTAIN POINTS
########################################################################
def plot_generated_images(epoch, generator, class_label):
    examples = 100
    noise= generate_noise(examples)
    generated_images = generator.predict(noise)
    generated_images = generated_images.reshape(examples, 28, 28)
    plt.figure(figsize=(10, 10))
    plt.gray()
    for i in range(examples):
        plt.subplot(10, 10, i + 1)
        plt.imshow(generated_images[i], interpolation='nearest')
        plt.axis('off')
    plt.tight_layout()
    plt.savefig(OUTPUT_DIRECTORY + '/%depoch_%d.png' % (class_label, epoch))
    plt.close()

########################################################################
#    TRAIN A GAN FOR GIVEN DATA
########################################################################
def make_gan(x_train, y_train, class_label):
    print('Making discriminator model...')
    discriminator = get_discriminator()
    discriminator.compile(loss='binary_crossentropy', optimizer=get_optimizer())

    print('Making generator model...')
    generator = get_generator()

    print('Making adversarial model...')
    make_trainable(discriminator, False)
    adversarial = Sequential()
    adversarial.add(generator)
    adversarial.add(discriminator)
    adversarial.compile(loss='binary_crossentropy', optimizer=get_optimizer())

    print('Preprocessing images...')
    x_train = preprocess_images(x_train)
    batch_count = len(x_train) // BATCH_SIZE
    half_batch_size = BATCH_SIZE // 2

    discriminator_loss = []
    generator_loss = []

    print('Begin training...')

    for e in range(1, GAN_EPOCHS + 1):
        discriminator_loss_epoch = []
        generator_loss_epoch = []

        for _ in range(batch_count):

            # Discriminator

            # images: half real input, half fake/generated
            real_images, real_labels = get_real_input(x_train, half_batch_size)
            fake_images, fake_labels = get_fake_input(generator, half_batch_size)
            x = np.concatenate([real_images, fake_images])
            y = np.concatenate([real_labels, fake_labels])

            # train discriminator
            make_trainable(discriminator, True)
            dis_loss_epoch = discriminator.train_on_batch(x, y)
            discriminator_loss_epoch.append(dis_loss_epoch)
            make_trainable(discriminator, False)
            # Generator

            # Adversarial

            x, y = get_gan_input(BATCH_SIZE)

            # train adversarial
            gen_loss_epoch = adversarial.train_on_batch(x, y)
            generator_loss_epoch.append(gen_loss_epoch)

        # add average loss for this epoch to list of average losses
        dis_loss = sum(discriminator_loss_epoch) / len(discriminator_loss_epoch)
        gen_loss = sum(generator_loss_epoch) / len(generator_loss_epoch)
        discriminator_loss.append(dis_loss)
        generator_loss.append(gen_loss)
        print('Epoch %d/%d | Gen loss: %.2f | Dis loss: %.2f' % (e, GAN_EPOCHS, gen_loss, dis_loss))

        # checkpoint every n epochs
        if e == 1 or e % CHECKPOINT == 0:
            plot_generated_images(e, generator, class_label)

    print('Complete.')
    return generator

########################################################################
#    BEGIN EXECUTION
########################################################################
mnist_data = setup_data()

for class_label in range(10):
    print('=============================')
    print(' Training a GAN for class %d ' % class_label)
    print('=============================')
    x_train = mnist_data[class_label]
    class_vector = utils.to_categorical(class_label, 10)
    y_train = class_vector * x_train.shape[0]
    generator_model = make_gan(x_train, y_train, class_label)

    generator_model.save(OUTPUT_DIRECTORY + '/gan-model-%d.model' % class_label)
    coreml_model = convert(generator_model)
    coreml_model.save(OUTPUT_DIRECTORY + '/gan-model-%d.mlmodel' % class_label)
    # if you want to work in Playgrounds then go compile it on the command linem with
    # $ xcrun coremlcompiler compile MnistGan.mlmodel MnistGan.mlmodelc

print('Complete.')
