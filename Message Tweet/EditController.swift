//
//  EditController.swift
//  Message Tweet
//
//  Created by Ryan Batchelder on 12/30/14.
//  Copyright (c) 2014 Ryan Batchelder. All rights reserved.
//

import Cocoa

class EditViewController : NSViewController
{
    @IBOutlet weak var LengthLabel: NSTextField!
    var message:String = ""
    let maxLength:Int = 140
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TweetField.stringValue = self.message
        checkTweetLength()
    }
    
    func checkTweetLength()
    {
        var length:Int = countElements(TweetField.stringValue)
        LengthLabel.stringValue = String(maxLength - length)
        if maxLength - length < 0
        {
            LengthLabel.textColor = NSColor.redColor()
        }
        else
        {
            LengthLabel.textColor = NSColor.blackColor()
        }
    }
    
    @IBOutlet weak var TweetField: NSTextField!
    @IBOutlet weak var TweetButton: NSButton!
    @IBAction func TweetButtonClicked(sender: AnyObject) {
    }
    
    @IBAction func textChanged(sender: AnyObject) {
        checkTweetLength()
    }
    @IBAction func BackButtonPressed(sender: AnyObject) {
        dismissViewController(self)
    }
    
}
