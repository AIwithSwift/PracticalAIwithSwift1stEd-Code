import CreateML


let dataTable: MLDataTable
let userColumn: String // column type must be Int or String
let itemColumn: String // column type must be Int or String
let ratingColumn: String? = nil

// =DEFAULT VALUES=
// let parameters = MLRecommender.ModelParameters(
//     algorithm: .itemSimilarity(SimilarityType.jaccard),
//     threshold: 0.001
//     maxCount: 64,
//     nearestItems: nil,
//     maxSimilarityIterations: 1024
// )
let parameters: MLRecommender.ModelParameters = ModelParameters()

let metadata = MLModelMetadata(
    author: "Mars Geldard",
    shortDescription: "A recommender model trained on <data> using CreateML, for use with CoreML.",
    license: "MIT",
    version: "1.0",
    additional: ["Note": "This model was created as part of an example for the book 'Practical Artificial Intelligence with Swift', published in 2019."]
)

if let recommender = try? MLRecommender(trainingData: trainingData, userColumn: userColumn, itemColumn: itemColumn, ratingColumn: ratingColumn, parameters: parameters) {
    recommender.write(to: filepath, metadata: metadata, maxCount: parameters.maxCount)
    
    let items: [MLIdentifier] = []
    
    let similarItems = recommender.getSimilarItems(fromItems: items)[itemColumn]
    let itemList = enumerate(similarItems).map { element in "Item \(element[0]): \(element[1])\n"}
    print("Similar items\n===============\n\(itemList)")
}


