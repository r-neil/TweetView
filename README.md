# TweetView
TweetView pulls the latest tweet from any user name on twitter.

#Requirments
The device that runs TweetView needs to be logged into a Twitter account (Settings->Twitter).  App was written in xCode 7.0.1.  May not run on older version of xCode.  

#Known “Bug”

When running in the Simulator you may notice a “_BSMachError: (os/kern) invalid capability (20)” or “_BSMachError: (os/kern) invalid name (15)” error in the debug log.  Researching this error it appears to be a bug with iOS 9 and the UIKeyboard.  It doesn’t affect the app.  

