import Foundation
import CreateML

// BEGIN regswload
let houseDatasetPath = "/Users/parisba/ORM Projects/Practical AI " + 
    "with Swift 1st Edition/PAISw1StEdCode/Regressor/housing.csv"

let houseDataset = try MLDataTable(contentsOf: 
    URL(fileURLWithPath: houseDatasetPath))
// END regswload
// BEGIN regswreg
let priceRegressor = try MLRegressor(
    trainingData: houseDataset, targetColumn: "MEDV")
// END regswreg
// BEGIN regswmet
let regressorMetadata = MLModelMetadata(
    author: "Paris B-A", 
    shortDescription: "A regressor for house prices.", 
    version: "1.0")
// END regswmet
// BEGIN regswwrite
let modelPath = "/Users/parisba/ORM Projects/Practical AI with Swift" + 
    "1st Edition/PAISw1StEdCode/Regressor/Housing.mlmodel"

try priceRegressor.write(
    to: URL(fileURLWithPath: modelPath), 
    metadata: regressorMetadata)
// END regswwrite
