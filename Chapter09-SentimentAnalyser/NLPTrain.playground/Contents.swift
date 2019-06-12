import CreateML
import Foundation

// Configure as required
let inputFilepath = "/Users/mars/Desktop/"
let inputFilename = "epinions3"
let outputFilename = "SentimentClassificationModel"

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: inputFilepath + inputFilename + ".csv"))
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

print("Begin training...")

do {
    let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
    
    // Final training accuracy as percentages
    let trainingAccuracy = (1.0 - sentimentClassifier.trainingMetrics.classificationError) * 100
    let validationAccuracy = (1.0 - sentimentClassifier.validationMetrics.classificationError) * 100
    print("Training evaluation: \(trainingAccuracy), \(validationAccuracy)")
    
    // Testing accruacy as a percentage
    //let evaluationMetrics = sentimentClassifier.evaluation(on: testingData) // Mojave
    let evaluationMetrics = sentimentClassifier.evaluation(on: trainingData, textColumn: "text", labelColumn: "class") // Catalina
    let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100
    print("Testing evaluation: \(evaluationAccuracy)")
    
    let metadata = MLModelMetadata(author: "Mars Geldard", shortDescription: "Sentiment analysis model", version: "1.0")
    
    try sentimentClassifier.write(to: URL(fileURLWithPath: inputFilepath + outputFilename + ".mlmodel"), metadata: metadata)
} catch {
    print("Error: \(error)")
}
