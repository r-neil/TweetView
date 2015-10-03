//
//  Tweet.swift
//  TweetView
//
//  Created by Neil on 10/1/15.
//  Copyright © 2015 r-neil. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var tweetMessage: String?
    var tweetUserName: String?
    var tweetUserDisplayName: String?
    var tweetUserProfileImg: UIImage?
    var setTweetTime: String?
    var getTweetTime: String?
        {
            get{
                let tempNSDate = setTweetTime!.setTwitterDate
                let tempDateStr = tempNSDate!.setTwitterTimeStr
                return tempDateStr!
            }
        }
    var getTweetDate: String?{
        get{
            let tempNSDate = setTweetTime!.setTwitterDate
            let tempDateStr = tempNSDate!.setTwitterDateStr
            return tempDateStr!
        }
    }
}

private extension String {
    var setTwitterDate: NSDate?{
        get{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            return dateFormatter.dateFromString(self)
        }
    }
}
private extension NSDate{
    var setTwitterTimeStr: String?{
        get{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.stringFromDate(self)
        }
    }
    var setTwitterDateStr: String?{
        get{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM d"
            return dateFormatter.stringFromDate(self)
        }
    }
    
}