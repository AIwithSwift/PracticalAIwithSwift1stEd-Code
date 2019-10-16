// BEGIN nlp_createml_playground1
import CreateML
import Foundation

// Configure as required
let inputFilepath = "/Users/mars/Desktop/"
let inputFilename = "epinions3"
let outputFilename = "SentimentClassificationModel"

let dataURL = URL(fileURLWithPath: inputFilepath + inputFilename + ".csv")
let data = try MLDataTable(contentsOf: dataURL)
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)
// END nlp_createml_playground1

// BEGIN nlp_createml_playground2
print("Begin training...")

do {
    // BEGIN nlp_createml_step1
    let sentimentClassifier = try MLTextClassifier(
        trainingData: trainingData, 
        textColumn: "text", 
        labelColumn: "class")
    // END nlp_createml_step1

    // Final training accuracy as percentages
    // BEGIN nlp_createml_step2
    let trainingAccuracy = 
        (1.0 - sentimentClassifier.trainingMetrics.classificationError) 
            * 100

    let validationAccuracy = 
        (1.0 - sentimentClassifier.validationMetrics.classificationError) 
            * 100

    print("Training evaluation: \(trainingAccuracy), " +
        "\(validationAccuracy)")
    // END nlp_createml_step2
    
    // BEGIN nlp_createml_step3
    // Testing accuracy as a percentage

    // let evaluationMetrics = 
    //    sentimentClassifier.evaluation(on: testingData) // Mojave

    let evaluationMetrics = sentimentClassifier.evaluation(
        on: testingData, 
        textColumn: "text", 
        labelColumn: "class") // Catalina

    let evaluationAccuracy = 
        (1.0 - evaluationMetrics.classificationError) * 100

    print("Testing evaluation: \(evaluationAccuracy)")
    
    let metadata = MLModelMetadata(
        author: "Mars Geldard", 
        shortDescription: "Sentiment analysis model", 
        version: "1.0")
    
    try sentimentClassifier.write(
        to: URL(
            fileURLWithPath: inputFilepath + outputFilename + ".mlmodel"), 
        metadata: metadata)
    // END nlp_createml_step3
} catch {
    print("Error: \(error)")
}
// END nlp_createml_playground2
