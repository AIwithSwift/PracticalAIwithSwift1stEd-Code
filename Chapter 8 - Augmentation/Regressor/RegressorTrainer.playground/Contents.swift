import Foundation
import CreateML
// BEGIN regswload
let houseDataset = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/parisba/ORM Projects/Practical AI with Swift 1st Edition/PAISw1StEdCode/Regressor/housing.csv"))
// END regswload
// BEGIN regswreg
let priceRegressor = try MLRegressor(trainingData: houseDataset, targetColumn: "MEDV")
// END regswreg
// BEGIN regswmet
let regressorMetadata = MLModelMetadata(author: "Paris B-A", shortDescription: "A regressor for house prices.", version: "1.0")
// END regswmet
// BEGIN regswwrite
try priceRegressor.write(to: URL(fileURLWithPath: "/Users/parisba/ORM Projects/Practical AI with Swift 1st Edition/PAISw1StEdCode/Regressor/Housing.mlmodel"), metadata: regressorMetadata)
// END regswwrite
