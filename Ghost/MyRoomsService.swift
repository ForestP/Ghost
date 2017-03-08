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
    func noRooms()
    func roomLoaded(roomNum: String?, memberCount: Int?, roomData: Dictionary<String,AnyObject>?)
}

class MyRoomsService {
    private static let _instance = MyRoomsService()
    
    weak var delegate: MyRoomsServiceDelegate?
    
    static var instance: MyRoomsService {
        return _instance
    }
    
    let ds = DataService.instance
    var currentUid = ""
    var noRooms = false
    
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
            } else {
                print("No Rooms")
                self.delegate?.noRooms()
            }
        })

        
    }
    
    func getRoomData(roomNum: String) {
        
        ds.roomRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
            if let roomData = snapshot.value as? Dictionary<String, AnyObject> {
                self.verifyRoom(roomData: roomData, roomNum: roomNum)
            }
        })
        

    }
    
    func verifyRoom(roomData: Dictionary<String, AnyObject>, roomNum: String) {

        let lengthOfDay = 86400000.0
        
        if let createdDate = roomData["createdDate"] as? Int {
            if var currentDate = NSDate().timeIntervalSince1970 as Double? {
                currentDate = currentDate * 1000
                let remainingTime = (Double(createdDate) + lengthOfDay) - currentDate
                if remainingTime <= 0 {
                    print("delete room")
                    
                    // Add delete room func
                    ds.removeRoomAndContents(roomId: roomNum)
                    // reload rooms
                } else {
                    // Get rest of info
                    self.getRoomMembers(roomData: roomData, roomNum: roomNum)
                }
            }
        }

    }
    
    func getRoomMembers(roomData: Dictionary<String, AnyObject>, roomNum: String) {
        ds.roomMemberRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value!)
            if let roomMembers = snapshot.value as? Dictionary<String, AnyObject> {
                
                let memberCount = roomMembers.count
                self.delegate?.roomLoaded(roomNum: roomNum, memberCount: memberCount, roomData: roomData)
            }
        })
    }

}
