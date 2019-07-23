import Foundation
import CreateML
import CoreML

/*:
 # Movie Recommender
 
 Due to restriction of data redistribution as per usage restrictions below, it must be downloaded and dragged into the Playground's Resources folder in the left sidebar as a **CSV** file named **MovieData.csv**. There are many mirrors, but the author used the nicely-collated version on [Kaggle](https://www.kaggle.com/netflix-inc/netflix-prize-data) and reformatted it using the included `preparation.py` file.
 
 ## Usage Guidelines from [UCI's WebArchive of Dataset](https://web.archive.org/web/20090925184737/http://archive.ics.uci.edu/ml/datasets/Netflix+Prize)
 
 Netflix can not guarantee the correctness of the data, its suitability for any
 particular purpose, or the validity of results based on the use of the data set.
 The data set may be used for any research purposes under the following
 conditions:
 
 * The user may not state or imply any endorsement from Netflix.
 
 * The user must acknowledge the use of the data set in
 publications resulting from the use of the data set, and must
 send us an electronic or paper copy of those publications.
 
 * The user may not redistribute the data without separate
 permission.
 
 * The user may not use this information for any commercial or
 revenue-bearing purposes without first obtaining permission
 from Netflix.
 */

let csvFile = Bundle.main.url(forResource: "netflix-priza-data", withExtension: "csv")!
let userColumn = "CustomerID"
let itemColumn = "Movie"
let ratingColumn = "Rating"
let outputFilepath = "/Users/mars/Desktop/recommender.mlmodel"

let metadata = MLModelMetadata(
    author: "Mars Geldard",
    shortDescription: "A recommender model trained on Netflix's Priza Dataset using CreateML, for use with CoreML.",
    license: "MIT",
    version: "1.0",
    additional: ["Note": "This model was created as part of an example for the book 'Practical Artificial Intelligence with Swift', published in 2019."]
)

if #available(OSX 10.15, *), let dataTable = try? MLDataTable(contentsOf: csvFile) {
    
    print("Got data!")
    
    let (evaluationData, trainingData) = dataTable.randomSplit(by: 0.20, seed: 5)

    // =DEFAULT VALUES=
    // let parameters = MLRecommender.ModelParameters(
    //     algorithm: .itemSimilarity(SimilarityType.jaccard),
    //     threshold: 0.001
    //     maxCount: 64,
    //     nearestItems: nil,
    //     maxSimilarityIterations: 1024
    // )
    let parameters: MLRecommender.ModelParameters = MLRecommender.ModelParameters()
    
    print("Configured setup!")
    
    let model = try? MLRecommender(
        trainingData: trainingData,
        userColumn: userColumn,
        itemColumn: itemColumn,
        ratingColumn: ratingColumn,
        parameters: parameters
    )
    
    print("Trained model!")
    
    let testItems: [MLIdentifier] = [
        "Les Miserables in Concert"
    ]
    
    if let filepath = URL(string: outputFilepath), let recommender = model {
        try? recommender.write(to: filepath, metadata: metadata)
        
        let metrics = recommender.evaluation(on: evaluationData, userColumn: userColumn, itemColumn: itemColumn, ratingColumn: ratingColumn)
        print(metrics)
        
        if let similarItemsColumn = try? recommender.getSimilarItems(fromItems: testItems)[itemColumn] {
            let similarItems = Array(similarItemsColumn).enumerated()
            let itemList = similarItems.map { tuple in "Item \(testItems[tuple.offset]): \(tuple.element)\n"}
            print("Similar items\n===============\n\(itemList)")
        }
    }
}





