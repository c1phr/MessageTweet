//
//  EditController.swift
//  Message Tweet
//
//  Created by Ryan Batchelder on 12/30/14.
//  Copyright (c) 2014 Ryan Batchelder. All rights reserved.
//

import Cocoa
import Accounts
import SwifterMac

class EditViewController : NSViewController
{
    @IBOutlet weak var LengthLabel: NSTextField!
    var message:String = ""
    let maxLength:Int = 140
    var twitterAccount:ACAccount = ACAccount()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TweetField.stringValue = self.message
        checkTweetLength()
    }
    
    func checkTweetLength() -> Bool
    {
        var length:Int = countElements(TweetField.stringValue)
        LengthLabel.stringValue = String(maxLength - length)
        if maxLength - length < 0
        {
            LengthLabel.textColor = NSColor.redColor()
            return false
        }
        else
        {
            LengthLabel.textColor = NSColor.blackColor()
            return true
        }
    }
    
    @IBOutlet weak var TweetField: NSTextField!
    @IBOutlet weak var TweetButton: NSButton!
    @IBAction func TweetButtonClicked(sender: AnyObject) {
        if checkTweetLength()
        {
            let swifter = Swifter(account: twitterAccount)
            swifter.postStatusUpdate(TweetField.stringValue, inReplyToStatusID: nil, lat: nil, long: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, success:{
                (status: Dictionary<String, JSONValue>?) in
                self.dismissViewController(self)

            }, failure: {
                (error: NSError) in
            })
        }
        else
        {
            let lengthPopup:NSAlert = NSAlert()
            lengthPopup.messageText = "Tweet too long!"
            lengthPopup.informativeText = "Your tweet is too long!"
            lengthPopup.runModal()
        }
    }
    
    @IBAction func textChanged(sender: AnyObject) {
        checkTweetLength()
    }
    @IBAction func BackButtonPressed(sender: AnyObject) {
        dismissViewController(self)
    }
    
}
