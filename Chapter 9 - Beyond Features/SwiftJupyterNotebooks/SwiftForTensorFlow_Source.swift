// We use a Jupyter Notebook to run this, but our snippet processor can't
// read it because the source code is embedded in the JSON. We're therefore
// making a copy of the source, so that we _can_ use our snippet system.

// BEGIN S4T_starter_1
import TensorFlow
// END S4T_starter_1

// BEGIN S4T_starter_2
let x = Tensor<Float>([[1, 2], [3, 4]])
// END S4T_starter_2

// BEGIN S4T_starter_3
print(x)
// END S4T_starter_3