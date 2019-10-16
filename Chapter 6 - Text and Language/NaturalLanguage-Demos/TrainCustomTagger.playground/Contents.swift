// BEGIN CTD_training_imports
import Foundation
import CreateML
// END CTD_training_imports

// BEGIN CTD_training_data1
let dataPath = "/Users/parisba/ORM Projects/Practical AI with Swift " +
    "1st Edition/PracticalAIwithSwift1stEd-Code/ChapterXX-" + 
    "NaturalLanguage/Reviews.json"

let rawData = URL(fileURLWithPath: dataPath)

let dataset = try MLDataTable(contentsOf: rawData)

let (trainingData, testData) = dataset.randomSplit(by: 0.8, seed: 7)
// END CTD_training_data1

// BEGIN CTD_training_data2
let model  = try MLTextClassifier(
    trainingData: trainingData, 
    textColumn: "text", 
    labelColumn: "label")

let metrics = model.evaluation(
    on: testData, 
    textColumn: "text", 
    labelColumn: "label")

let accuracy = (1 - metrics.classificationError) * 100
let confusion = metrics.confusion
// END CTD_training_data2

// BEGIN CTD_training_data3
let modelPath = "/Users/parisba/ORM Projects/Practical AI with Swift" + 
    "1st Edition/PracticalAIwithSwift1stEd-Code/ChapterXX-" + 
    "NaturalLanguage/ReviewMLTextClassifier.mlmodel"

let coreMLModel = URL(fileURLWithPath: modelPath)
try model.write(to: coreMLModel)
// END CTD_training_data3
