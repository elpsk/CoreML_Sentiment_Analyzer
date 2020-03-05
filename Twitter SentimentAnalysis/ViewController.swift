//
//  ViewController.swift
//  Twitter SentimentAnalysis
//
//  Created by Pasca Alberto, IT on 02/03/2020.
//  Copyright © 2020 albertopasca.it. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var searchText: UITextField!
    
    let swifter = Swifter(
        consumerKey: "<#twitter-key#>",
        consumerSecret: "<#twitter-secret#>")

    let sentimentClassifier = TweetSentimentClassifier()

    override func viewDidLoad() {
        super.viewDidLoad()

//        let predition = try! sentimentClassifier.prediction(text: "@Apple is a terrible company!")
//        print( predition.label )

        searchText.delegate = self
    }

    func sentimentAnalyze( key: String ) {

        swifter.searchTweet(
            using: key,
            lang: "en",
            count: 100,
            tweetMode: .extended,
            success: { results, metadata in

                var tweets = [TweetSentimentClassifierInput]()
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append( tweetForClassification )
                    }
                }

                do {
                    var sentimentScore = 0

                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    for prediction in predictions {
                        let sentiment = prediction.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        } else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                    }
                    
                    // 😁☹️😑
                    print( sentimentScore )

                    if sentimentScore > 20 {
                        self.scoreLabel.text = "😍"
                    } else if sentimentScore > 10 {
                        self.scoreLabel.text = "😀"
                    } else if sentimentScore > 0 {
                        self.scoreLabel.text = "🙂"
                    } else if sentimentScore > -10 {
                        self.scoreLabel.text = "🙁"
                    } else if sentimentScore > -20 {
                        self.scoreLabel.text = "😡"
                    } else {
                        self.scoreLabel.text = "🤮"
                    }

                } catch {}

        }) { _ in }

    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text {
            sentimentAnalyze(key: text )
        }

        return true
    }
    
}
