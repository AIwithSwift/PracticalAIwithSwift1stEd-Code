// BEGIN rec_imports
import Foundation
import CreateML
import CoreML
// END rec_imports

/*:
 # Movie Recommender

 Due to restriction of data redistribution as per usage restrictions below,
 it must be downloaded and dragged into the Playground's Resources folder
 in the left sidebar as a **CSV** file named **MovieData.csv**. There are
 many mirrors, but the author used the nicely-collated version on
 [Kaggle](https://www.kaggle.com/netflix-inc/netflix-prize-data) and
 reformatted it using the included `preparation.py` file.

 ## Usage Guidelines from [UCI's WebArchive of Dataset](https://web.archive.org/web/20090925184737/http://archive.ics.uci.edu/ml/datasets/Netflix+Prize)

 Netflix can not guarantee the correctness of the data, its suitability for
 any particular purpose, or the validity of results based on the use of the
 data set. The data set may be used for any research purposes under the
 following conditions:

 * The user may not state or imply any endorsement from Netflix.

 * The user must acknowledge the use of the data set in publications
   resulting from the use of the data set, and must send us an electronic
   or paper copy of those publications.

 * The user may not redistribute the data without separate permission.

 * The user may not use this information for any commercial or
   revenue-bearing purposes without first obtaining permission from
   Netflix.
 */

// BEGIN rec_file
let csvFile = Bundle.main.url(forResource: nil, withExtension: "csv")!
// END rec_file

// BEGIN rec_vars
let userColumn = "CustomerID"
let itemColumn = "MovieID"
let ratingColumn = "Rating"
let titleColumn = "Movie"
let outputFilepath = URL(string: "~/recommender.mlmodel")!
// END rec_vars

// BEGIN rec_metadata
let metadata = MLModelMetadata(
    author: "Mars Geldard",
    shortDescription: "A recommender model trained on Netflix's " + 
        "Prize Dataset using CreateML, for use with CoreML.",
    license: "MIT",
    version: "1.0",
    additional: [
        "Note": "This model was created as part of an example for " +
        "the book 'Practical Artificial Intelligence with Swift', " + 
        "published in 2019."
    ]
)
// END rec_metadata

// BEGIN rec_train
if #available(OSX 10.15, *), 
    let dataTable = try? MLDataTable(contentsOf: csvFile) {
    
    print("Got data!")
    
    // =DEFAULT VALUES=
    // let parameters = MLRecommender.ModelParameters(
    //     algorithm: .itemSimilarity(SimilarityType.jaccard),
    //     threshold: 0.001
    //     maxCount: 64,
    //     nearestItems: nil,
    //     maxSimilarityIterations: 1024
    // )
    // BEGIN rec_train1
    let parameters: MLRecommender.ModelParameters = 
        MLRecommender.ModelParameters()
    
    print("Configured setup!")
    // END rec_train1
    
    // BEGIN rec_train2
    var model: MLRecommender? = nil
    // END rec_train2
    
    // BEGIN rec_train3
    do {
        model = try MLRecommender(
            trainingData: dataTable,//trainingData,
            userColumn: userColumn,
            itemColumn: itemColumn,
            ratingColumn: ratingColumn,
            parameters: parameters
        )
    } catch let error as MLCreateError {
        switch error {
            case .io(let reason): print("IO error: \(reason)")
            case .type(let reason): print("Type error: \(reason)")
            case .generic(let reason): print("Generic error: \(reason)")
        }
    } catch {
        print("Error training model: \(error.localizedDescription)")
    }
    // END rec_train3
    
    // BEGIN rec_train4
    if let recommender = model {
        // BEGIN rec_train4_1
        print("Trained model!")
        
        try? recommender.write(to: outputFilepath, metadata: metadata)
        // END rec_train4_1
        // BEGIN rec_train4_2
        let userIdColumnValues: MLDataColumn<Int> = 
            dataTable[userColumn]
            
        let movieIdColumnValues: MLDataColumn<Int> = 
            dataTable[itemColumn]
            
        let ratingsColumnValues: MLDataColumn<Int> = 
            dataTable[ratingColumn]
            
        let movieColumnValues: MLDataColumn<String> = 
            dataTable[titleColumn]
            
        
        let testUsers: [Int] = [
            0, 1, 2, 3, 100, 324, 500
        ]
        
        let threshold = 0.75
        // END rec_train4_2
        // BEGIN rec_train4_3
        if let userRecommendations = 
            try? recommender.recommendations(
                fromUsers: testUsers as [MLIdentifier]) {

            let recsUserColumnValues: MLDataColumn<Int> =
                 userRecommendations[userColumn]

            let recsMovieColumnValues: MLDataColumn<Int> =
                 userRecommendations[itemColumn]

            let recsScoreColumnValues: MLDataColumn<Double> =
                 userRecommendations["score"]

            print(userRecommendations)
            
            for user in testUsers {
                print("\nUser \(user) likes:")
                
                // get current ratings
                let userMask = (userIdColumnValues == user)
                let currentTitles = Array(movieColumnValues[userMask])
                let currentRatings = Array(ratingsColumnValues[userMask])
                let userRatings = zip(currentTitles, currentRatings)
                
                userRatings.forEach { title, rating in
                    print(" -  \(title) (\(rating) stars)")
                }
                
                print("\nRecommendations for User \(user):")
                
                let recsUserMask  = (recsUserColumnValues == user)

                let recommendedMovies = 
                    Array(recsMovieColumnValues[recsUserMask])

                let recommendedScores = 
                    Array(recsScoreColumnValues[recsUserMask])

                let recommendations = 
                    zip(recommendedMovies, recommendedScores)

                recommendations.forEach { movieId, score in
                    if score > threshold {
                        
                        // get title
                        let movieMask = (movieIdColumnValues == movieId)
                        let title = 
                            Array(movieColumnValues[movieMask]).first ?? 
                                "<Unknown Title>"
                        
                        print(" - \(title)")
                    }
                }
            }
        }
        // rec_train4_3
    }
    // END rec_train4
}
// END rec_train




