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
import SQLite

class ViewController: NSViewController {
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
        
        println(getMessages())
        // Populate list of messages
    }
    
    func getMessages() -> Array<String>
    {
        var messages = [String]()
        var relations = [Int]()
        let db = Database("~/Library/Messages/chat.db", readonly: true)
        let message_db = db["message"]
        let chat_message_join = db["chat_message_join"]
        let message_text = Expression<String>("text")
        let rowid = Expression<Int>("ROWID")
        let chat_id = Expression<Int>("chat_id")
        let message_id = Expression<Int>("message_id")
        
        let message_relation = chat_message_join.select(message_id).filter(chat_id == 76)
        
        for relation in message_relation
        {
            relations.append(relation[message_id])
        }
        
        let query = message_db.select(message_text).filter(contains(relations, rowid)).order(rowid.desc).limit(10)
        
        for message in query
        {
            messages.append(message[message_text])
        }
        
        return messages
    }
}