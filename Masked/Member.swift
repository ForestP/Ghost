//
//  Member.swift
//  Masked
//
//  Created by Forest Plasencia on 2/15/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase

struct Member {
    let uid: String
    let userNum: String
}

extension Member {
    
    // parse message from firebase
    static func parseMessage(snapshot: FIRDataSnapshot) -> Member? {
        
        let snapshot = snapshot
        
        if let uid = snapshot.key as? String,
            let userNum = snapshot.value as? String {
          
                
                return Member (
                    uid: uid,
                    userNum: userNum
                )
            
            
        }
        
        return nil
    }
    
    
    
}
