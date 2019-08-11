import Foundation
import CreateML

let trainingData = try MLDataTable(contentsOf: ")


////1
//let houseData = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/Path/To/HouseData.csv"))
//let (trainingCSVData, testCSVData) = houseData.randomSplit(by: 0.8, seed: 0)
////2
//let pricer = try MLRegressor(trainingData: houseData, targetColumn: "MEDV")
////3
//let csvMetadata = MLModelMetadata(author: "Sai Kambampati", shortDescription: "A model used to determine the price of a house based on some features.", version: "1.0")
//try pricer.write(to: URL(fileURLWithPath: "/Users/Path/To/Write/HousePricer.mlmodel"), metadata: csvMetadata)
