// BEGIN thw_imports
import Accelerate
// END thw_imports

// BEGIN thw_filter_dec
var inputFilter: BNNSFilter?
var outputFilter: BNNSFilter?
// END thw_filter_dec

// BEGIN thw_functions
func buildNetwork(inputWeights: [Float],
                  inputBiases: [Float],
                  outputWeights: [Float],
                  outputBiases: [Float])
{
    // BEGIN thw_build_one
    let activation = BNNSActivation(function: .sigmoid, alpha: 0, beta: 0)
    
    let inputToHiddenWeightsData = BNNSLayerData(
        data: inputWeights,
        data_type: .float,
        data_scale: 0,
        data_bias: 0,
        data_table: nil)
    
    let inputToHiddenBiasData = BNNSLayerData(
        data: inputBiases,
        data_type: .float,
        data_scale: 0,
        data_bias: 0,
        data_table: nil)
    
    var inputToHiddenParameters = BNNSFullyConnectedLayerParameters(
        in_size: 2,
        out_size: 2,
        weights: inputToHiddenWeightsData,
        bias: inputToHiddenBiasData,
        activation: activation)
    
    // these describe the shape of the data being passed around
    var inputDescriptor = BNNSVectorDescriptor(
        size: 2,
        data_type: .float,
        data_scale: 0,
        data_bias: 0)
    
    var hiddenDescriptor = BNNSVectorDescriptor(
        size: 2,
        data_type: .float,
        data_scale: 0,
        data_bias: 0)
    
    inputFilter = BNNSFilterCreateFullyConnectedLayer(
        &inputDescriptor,
        &hiddenDescriptor,
        &inputToHiddenParameters,
        nil)

    guard inputFilter != nil else
    {
        return
    }
    // END thw_build_one
    
    // BEGIN thw_build_two
    let hiddenToOutputWeightsData = BNNSLayerData(
        data:outputWeights,
        data_type: .float,
        data_scale: 0,
        data_bias: 0,
        data_table: nil)
    
    let hiddenToOutputBiasData = BNNSLayerData(
        data: outputBiases,
        data_type: .float,
        data_scale: 0,
        data_bias: 0,
        data_table: nil)
    
    var hiddenToOutputParams = BNNSFullyConnectedLayerParameters(
        in_size: 2,
        out_size: 1,
        weights: hiddenToOutputWeightsData,
        bias: hiddenToOutputBiasData,
        activation: activation)
    
    var outputDescriptor = BNNSVectorDescriptor(
        size: 1,
        data_type: .float,
        data_scale: 0,
        data_bias: 0)
    
    outputFilter = BNNSFilterCreateFullyConnectedLayer(
        &hiddenDescriptor,
        &outputDescriptor,
        &hiddenToOutputParams,
        nil)

    guard outputFilter != nil else
    {
        print("error getting output")
        return
    }
    // END thw_build_two
}

func runNetwork(_ x: Float, _ y: Float) -> Float
{
    // BEGIN thw_run_vars
    var hidden: [Float] = [0, 0]
    var output: [Float] = [0]
    // END thw_run_vars
    
    // BEGIN thw_run_input_apply
    guard BNNSFilterApply(inputFilter, [x,y], &hidden) == 0 else
    {
        print("Hidden Layer failed.")
        return -1
    }
    // END thw_run_input_apply
    
    // BEGIN thw_run_output_apply
    guard BNNSFilterApply(outputFilter, hidden, &output) == 0 else
    {
        print("Output Layer failed.")
        return -1
    }
    // END thw_run_output_apply
    
    // BEGIN thw_run_output
    return output[0]
    // END thw_run_output
}

func destroyNetwork()
{
    // BEGIN thw_destroy
    BNNSFilterDestroy(inputFilter)
    BNNSFilterDestroy(outputFilter)
    // END thw_destroy
}
// END thw_functions

// BEGIN thw_creation
buildNetwork(
    inputWeights: [-6.344469 ,  6.5571136,  6.602744 , -6.2786956],
    inputBiases: [3.2028756, 3.1625535],
    outputWeights: [-7.916997 , -7.9228764],
    outputBiases: [11.601367])
// END thw_creation

// BEGIN thw_run_input
runNetwork(0, 0)
runNetwork(0, 1)
runNetwork(1, 0)
runNetwork(1, 1)
// END thw_run_input

// BEGIN thw_run_rounded
Int(runNetwork(1, 0).rounded())
// END thw_run_rounded

// BEGIN thw_run_loop
for a: Float in stride(from: 0, through: 1, by: 0.1)
{
    for b: Float in stride(from: 0, through: 1, by: 0.1)
    {
        runNetwork(a, b)
    }
}
// END thw_run_loop

// BEGIN thw_run_destroy
destroyNetwork()
// END thw_run_destroy
