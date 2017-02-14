//
//  DataService.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var userRef: FIRDatabaseReference {
        return mainRef.child(FIR_USER_REF)
    }
    
    var roomRef: FIRDatabaseReference {
        return mainRef.child(FIR_ROOM_REF)
    }
    
    var roomMemberRef: FIRDatabaseReference {
        return mainRef.child(FIR_ROOMMEMBER_REF)
    }
    
    var userRoomRef: FIRDatabaseReference {
        return mainRef.child(FIR_USERROOM_REF)
    }

    func addUserToRoom(uid: String, RoomId: String) {
        
        roomMemberRef.child(RoomId).child(uid).setValue("true")
        userRoomRef.child(uid).child(RoomId).setValue("true")
    }
    
    func removeRoomAndContents(roomId: String) {
        
        // remove room from userRooms
        roomMemberRef.child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let members = snapshot.value as? Dictionary<String, AnyObject> {
                for member in members {
                    if let id  = member.key as? String {
                        self.userRoomRef.child(id).child(roomId).removeValue()
                    }
                }
            }
            // remove room from roomMembers
            self.roomMemberRef.child(roomId).removeValue()
        })
        
        
        // remove messages
        // remove room from roomMessages
        
        // remove room
        roomRef.child(roomId).removeValue()
        
        
    }
    
}
