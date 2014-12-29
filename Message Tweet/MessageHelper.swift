//
//  MessageHelper.swift
//  Message Tweet
//
//  Created by Ryan Batchelder on 12/29/14.
//  Copyright (c) 2014 Ryan Batchelder. All rights reserved.
//

import Cocoa
import SQLite

class MessageHelper : NSObject, NSTableViewDataSource
{
    let messages:Array<String> = MessageHelper.getMessages()
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return messages.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return messages[row]
    }
    
    class func getMessages() -> Array<String>
    {
        var messages = [String]()
        var relations = [Int]()
        let db = Database("/Users/ryanbatchelder/Library/Messages/chat.db", readonly: true)
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
