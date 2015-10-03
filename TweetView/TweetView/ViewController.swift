//
//  ViewController.swift
//  TweetView
//
//  Created by r-neil 10/3/2015.
//  Copyright © 2015 r-neil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TwitterRequestDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var twitterUserNameTextField: UITextField!
    @IBOutlet weak var tweetView: UIView!
    @IBOutlet weak var tweetUserImg: UIImageView!
    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var tweetUserDisplayName: UILabel!
    @IBOutlet weak var tweetUserName: UILabel!
    @IBOutlet weak var tweetMessage: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let Twitter = TwitterRequest()
    
    let sampleTwitterArray = ["@Snowden","@007","@SethMacFarlane","@SpaceX","@tim_cook","@JerrySeinfeld","@elonmusk"]

    override func viewDidLoad() {
        super.viewDidLoad()
        blankOutTweetView()
        Twitter.delegate = self
        twitterUserNameTextField.delegate = self
        twitterUserNameTextField.text = randomTwitterUsername()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""{
            let firstChar = textField.text![textField.text!.startIndex]
            if firstChar == "@"{
                blankOutTweetView()
                Twitter.searchTwitter(textField.text!)
                twitterUserNameTextField.text = randomTwitterUsername()
                spinner.startAnimating()
            }
        }
        return true
    }
    
    func setSingleTweet(tweet: Tweet) {
        tweetUserName.text = tweet.tweetUserName!
        tweetUserDisplayName.text = tweet.tweetUserDisplayName!
        tweetMessage.text = tweet.tweetMessage!
        tweetTime.text = tweet.getTweetTime!
        tweetUserImg.image = tweet.tweetUserProfileImg!
        tweetDate.text = tweet.getTweetDate
        tweetView.layer.borderColor = UIColor.grayColor().CGColor
        tweetView.layer.borderWidth = 1.0
        spinner.stopAnimating()
    }
    
    func randomTwitterUsername() ->String{
        let randomIndex = Int(arc4random_uniform(UInt32(sampleTwitterArray.count)))
        return sampleTwitterArray[randomIndex]
    }
    
    func blankOutTweetView(){
        tweetUserName.text = ""
        tweetUserDisplayName.text = ""
        tweetMessage.text = ""
        tweetTime.text = ""
        tweetUserImg.image = nil
        tweetDate.text = ""
    }
    
}

