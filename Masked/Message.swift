//
//  Post.swift
//  Masked
//
//  Created by Forest Plasencia on 2/14/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    let msgText: String
    let postedBy: String
}

extension Message {
    
    // parse message from firebase
    static func parseMessage(snapshot: FIRDataSnapshot) -> Message? {
        
        let snapshot = snapshot
        
        if let msgData = snapshot.value as? Dictionary<String, AnyObject> {
            if let msgText = msgData["msgText"] as? String,
                let postedBy = msgData["userNum"] as? String {
                
                return Message (
                    msgText: msgText,
                    postedBy: postedBy
                )
            }
            
        }
        
        return nil
    }
    

    
}
