# BEGIN uth_python
import tensorflow as tf
import numpy as np

inputStream = tf.placeholder(tf.float32, shape=[4,2])
inputWeights = tf.Variable(tf.random_uniform([2,2], -1, 1))
inputBiases = tf.Variable(tf.zeros([2]))

outputStream = tf.placeholder(tf.float32, shape=[4,1])
outputWeights = tf.Variable(tf.random_uniform([2,1], -1, 1))
outputBiases = tf.Variable(tf.zeros([1]))

inputTrainingData = [[0,0],[0,1],[1,0],[1,1]]
outputTrainingData = [0,1,1,0]
# only reshaping the data because our training input is one-dimensional
outputTrainingData = np.reshape(outputTrainingData, [4,1])

# making two activations for ouy layers
hiddenNeuronsFormula = tf.sigmoid(tf.matmul(inputStream, inputWeights) + inputBiases)
outputNeuronFormula = tf.sigmoid(tf.matmul(hiddenNeuronsFormula, outputWeights) + outputBiases)

# the cost function for training, this is the number the training wants to minimise
cost = tf.reduce_mean(( (outputStream * tf.log(outputNeuronFormula)) + ((1 - outputStream) * tf.log(1.0 - outputNeuronFormula)) ) * -1)

train_step = tf.train.GradientDescentOptimizer(0.1).minimize(cost)
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)

# actually training the model
for i in range(10000):
    tmp_cost, _ = sess.run([cost,train_step], feed_dict={inputStream: inputTrainingData, outputStream: outputTrainingData})
    if i % 500 == 0:
        print("training iteration " + str(i))
        print('loss= ' + "{:.5f}".format(tmp_cost))

# reshaping the weights/biases into something easily printable
inputWeights = np.reshape(sess.run(inputWeights), [4,])
inputBiases = np.reshape(sess.run(inputBiases), [2,])
outputWeights = np.reshape(sess.run(outputWeights),[2,])
outputBiases = np.reshape(sess.run(outputBiases), [1,])

print('Input weights: ', inputWeights)
print('Input biases: ', inputBiases)
print('Output weights: ', outputWeights)
print('Output biases: ', outputBiases)
# END uth_python