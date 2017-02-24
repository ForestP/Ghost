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

    var messageRef: FIRDatabaseReference {
        return mainRef.child(FIR_MESSAGE_REF)
    }
    var roomMessageRef: FIRDatabaseReference {
        return mainRef.child(FIR_ROOMMESSAGE_REF)
    }
    
    func addUserToRoom(uid: String, RoomId: String, userNum: String) {
        
        roomMemberRef.child(RoomId).child(uid).setValue(userNum)
        userRoomRef.child(uid).child(RoomId).setValue("true")
        
        //roomRef.child(RoomId).child(FIR_TAKENNUMS_REF).updateChildValues([userNum : Int(userNum)!])
    }
    

    
    func removeRoomAndContents(roomId: String) {
        
        // remove room from userRooms FOR ALL MEMBERS
        roomMemberRef.child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let members = snapshot.value as? Dictionary<String, AnyObject> {
                for member in members {
                    let id  = member.key
                    self.userRoomRef.child(id).child(roomId).removeValue()
                }
                
            }
            // remove room from roomMembers
            self.roomMemberRef.child(roomId).removeValue()
        })
        
        
        // remove messages
        roomMessageRef.child(roomId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let messages = snapshot.value as? Dictionary<String,AnyObject> {
                for msg in messages {
                    let id = msg.key
                    self.messageRef.child(id).removeValue()
                }
            }
            // remove room from roomMessages
            self.roomMessageRef.child(roomId).removeValue()
        })
        
        // remove room
        roomRef.child(roomId).removeValue()
        
        
    }
    
    func signUserIn() {
        
    }
    
}
