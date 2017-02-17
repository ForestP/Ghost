//
//  MyRoomsService.swift
//  Masked
//
//  Created by Forest Plasencia on 2/16/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import Foundation
import Firebase

protocol MyRoomsServiceDelegate: class {
    func roomLoaded(roomNum: String?, memberCount: Int?)
}

class MyRoomsService {
    private static let _instance = MyRoomsService()
    
    weak var delegate: MyRoomsServiceDelegate?
    
    static var instance: MyRoomsService {
        return _instance
    }
    
    let ds = DataService.instance
    var currentUid = ""
    
    func getUsersRooms() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else{
            print("Could Not Load current uid")
            return
        }
        
        self.currentUid = uid
        
        ds.userRoomRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userRooms = snapshot.value as? Dictionary<String, AnyObject> {
                for room in userRooms {
                    let roomNum = room.key
                    self.getRoomData(roomNum: roomNum)
                }
            }
        })

        
    }
    
    func getRoomData(roomNum: String) {
        
        ds.roomMemberRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value!)
            if let roomMembers = snapshot.value as? Dictionary<String, AnyObject> {
                let memberCount = roomMembers.count
                self.delegate?.roomLoaded(roomNum: roomNum, memberCount: memberCount)
            }
        })
    }

}
