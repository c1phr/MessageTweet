//
//  ViewController.swift
//  Message Tweet
//
//  Created by Ryan Batchelder on 12/28/14.
//  Copyright (c) 2014 Ryan Batchelder. All rights reserved.
//

import Foundation
import Cocoa
import Accounts
import SwifterMac


class MessageViewController: NSViewController {
    var twitterAccount: ACAccount = ACAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            
            if granted
            {
                let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                
                if (twitterAccounts != nil)
                {
                    if twitterAccounts.count == 0
                    {
                        let alert:NSAlert = NSAlert()
                        alert.addButtonWithTitle("Close")
                        alert.messageText = "There are no Twitter accounts configured in System Preferences"
                        if alert.runModal() == NSAlertFirstButtonReturn
                        {
                            exit(-1)
                        }
                    }
                    else //We have some Twitter accounts to work with
                    {
                        for account in twitterAccounts
                        {
                            if account.username == "_AbusementPark_"
                            {
                                self.twitterAccount = account as ACAccount
                            }
                        }
                        if self.twitterAccount.description == ""
                        {
                            let alert:NSAlert = NSAlert()
                            alert.addButtonWithTitle("Close")
                            alert.messageText = "The _AbusementPark_ account is not configured in System Preferences"
                            if alert.runModal() == NSAlertFirstButtonReturn
                            {
                                exit(-1)
                            }
                        }
                    }
                }
            }
        }
    }
    @IBOutlet var messageHelper: MessageHelper!
    @IBOutlet weak var MessageTable: NSTableView!
    @IBOutlet weak var tweetButton: NSButton!
    @IBOutlet weak var selectButton: NSButton!
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTweet"
        {
            var dest = segue.destinationController as EditViewController
            dest.message = messageHelper.messages[MessageTable.selectedRow]
        }
    }
    
    @IBAction func selectButtonPressed(sender: NSButton) {
        self.performSegueWithIdentifier("EditTweet", sender: self)
        
    }
}