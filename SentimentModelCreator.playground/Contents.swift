import Cocoa
import CreateML

// tha path of your csv file
let baseFolder = "<#folder-path#>"
let data = try! MLDataTable(contentsOf: URL(fileURLWithPath: "\(baseFolder)/twitter-sanders-apple3.csv"))

let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

// classifier
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")
// metrics
let evaluationMetrics   = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")
// accuracy
let evaluationAccuract  = (1.0 - evaluationMetrics.classificationError) * 100

// metadata to export
let metadata = MLModelMetadata(
    author: "Alberto Pasca",
    shortDescription: "A model to classify tweets",
    license: "MIT",
    version: "1,0"
)
// save the generated *.mlmodel
try sentimentClassifier.write(to: URL(fileURLWithPath: "\(baseFolder)/TweetSentimentClassifier.mlmodel"))
