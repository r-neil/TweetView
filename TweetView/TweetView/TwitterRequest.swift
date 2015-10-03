//
//  TwitterRequest.swift
//  TweetView
//
//  Created by r-neil 10/3/2015.
//  Copyright © 2015 r-neil. All rights reserved.
//

import UIKit
import Accounts
import Social

protocol TwitterRequestDelegate{
    func setSingleTweet(tweet:Tweet)
}

class TwitterRequest{
    
    private var twitterAccount: ACAccount?
    private var twitterSearchParameters = Dictionary<String, String>()
    private typealias PropertyList = AnyObject
    lazy var LatestTweet = Tweet()
    var delegate: TwitterRequestDelegate?
    
    struct TwitterKey {
        static let numberOfTweets = "count"
        static let ExcludeReplies = "exclude_replies"
        static let UserName = "screen_name"
        static let IncludeRetweet = "include_rts"
        static let tweetText = "text"
        static let userInfo = "user"
        static let displayName = "name"
        static let userName = "screen_name"
        static let createTime = "created_at"
        static let profilePic = "profile_image_url_https"
        
        
    }
    //Method that kicks off search
    func searchTwitter(userName:String){
        setTwitterSearchParameters(userName.lowercaseString)
        performFetch()
    }
    //search parameters for Twitter Rest API
    //docs:https://dev.twitter.com/rest/reference/get/statuses/user_timeline
    
    let TwitterGetStatusesURL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    
    private func setTwitterSearchParameters(userName:String){
        twitterSearchParameters[TwitterKey.numberOfTweets] = "1"
        twitterSearchParameters[TwitterKey.ExcludeReplies] = "true"
        twitterSearchParameters[TwitterKey.UserName] = userName
        twitterSearchParameters[TwitterKey.IncludeRetweet] = "false"
    }
    
    private func performFetch(){
        if let account = twitterAccount{
            let request = SLRequest(forServiceType: SLServiceTypeTwitter,requestMethod: SLRequestMethod.GET, URL: NSURL(string: "\(TwitterGetStatusesURL)"), parameters: twitterSearchParameters)
                request.account = account
            
            var twitterSearchResponse : PropertyList?
                request.performRequestWithHandler(){(jsonResponse, httpResponse, _) in
                    if jsonResponse != nil{
                        do{
                            twitterSearchResponse = try NSJSONSerialization.JSONObjectWithData(jsonResponse, options: NSJSONReadingOptions.MutableLeaves)
                            self.sortJSONGCS(twitterSearchResponse)
                        }catch{
                            print(error)
                        }
                    }else{
                        print("No data from twitter")
                    }
                }
        }else{
            setupUserTwitterAccess()
        }
    }

    private func setupUserTwitterAccess(){
        let accountStore =  ACAccountStore() //all social accounts on User's iPhone
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter) //select Twitter Account
        
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil){(granted, _) in //request access to user's twitter account
            if granted{
                if let account = accountStore.accountsWithAccountType(twitterAccountType)?.last as? ACAccount{
                    self.twitterAccount = account
                    self.performFetch()
                }else{
                    print("Counld't find Twitter Account on device.  User may not have logged in")
                }
            }else{
                print("Access to Twitter not granted")
            }
            }
    }
    
    private func sortJSONGCS(json:PropertyList?){
        if let twitterDictionary = (json as? NSArray)!.firstObject as? NSDictionary{
                LatestTweet.tweetMessage =  getUserTweet(twitterDictionary)
                LatestTweet.tweetUserDisplayName = getUserDisplayName(twitterDictionary)
                LatestTweet.tweetUserName = getUserName(twitterDictionary)
                LatestTweet.setTweetTime = getTweetTime(twitterDictionary)
                getUserProfileImgThenCallDelegate(twitterDictionary)
        }
    }
    
    private func getUserProfileImgThenCallDelegate(twitterDictionary:NSDictionary){
        let profilePicData = twitterDictionary.valueForKey(TwitterKey.userInfo)?.valueForKey(TwitterKey.profilePic)
        if let profilePicURLStr = profilePicData as? String{
            let imgURL = NSURL(string: profilePicURLStr)
            let backgroundQ = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(backgroundQ, 0)) { () -> Void in
                if let imageData = NSData(contentsOfURL: imgURL!){
                    if imgURL != nil{
                        let fetchImg = UIImage(data: imageData)!
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.LatestTweet.tweetUserProfileImg = fetchImg
                            self.delegate?.setSingleTweet(self.LatestTweet)
                        })
                    }
                }
            }
        }
    }
    
    private func getUserName(twitterDictionary:NSDictionary)->String{
        let userName = twitterDictionary.valueForKey(TwitterKey.userInfo)?.valueForKey(TwitterKey.userName)
        if let userNameStr = userName as? String{
            return userNameStr
        }else{
            return ""
        }
    }
    
    private func getUserDisplayName(twitterDictionary:NSDictionary)->String{
        let displayName = twitterDictionary.valueForKey(TwitterKey.userInfo)?.valueForKey(TwitterKey.displayName)
        if let displayNameStr = displayName as? String{
            return displayNameStr
        }else{
            return ""
        }
    }
    
    private func getUserTweet(twitterDictionary:NSDictionary) -> String{
        let tweet = twitterDictionary.valueForKey(TwitterKey.tweetText)
        if let tweetStr = tweet as? String {
            return tweetStr
        }else{
            return ""
        }
    }
    
    private func getTweetTime(twitterDictionary:NSDictionary)->String{
        let time = twitterDictionary.valueForKey(TwitterKey.createTime)
        if let tweetTime = time as? String{
            return tweetTime
        }else{
            return ""
        }
    }
}


