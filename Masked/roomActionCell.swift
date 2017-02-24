//
//  roomActionCell.swift
//  Masked
//
//  Created by Forest Plasencia on 2/20/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase

class roomActionCell: UITableViewCell, NibLoadableView {

    let ds = DataService.instance
    
    var currentRooms = [String]()
    var currentUser: String?

    
    let createRoomSegue = "goToNewRoom"
    let joinRoomSegue = "goToJoinRoomVC"
    var vc: myRoomsVC?

    func configureCell(myRoomsVC: myRoomsVC, currentUser: String){
        self.backgroundColor = UIColor .clear
        
        self.vc = myRoomsVC
        self.currentUser = currentUser
    }
    
    @IBAction func createRoomPressed(_ sender: Any) {
        self.ds.roomRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let rooms = snapshot.value as? Dictionary<String, AnyObject> {
                for room in rooms {
                    self.currentRooms.append(room.key)
                    print(self.currentRooms)
                }
                
            }
            
            let roomId = self.generateRoom()
            self.vc?.createRoom(roomId: roomId)
            
        })
    }
    
    @IBAction func joinRoomPressed(_ sender: Any) {
        self.vc?.joinRoom()

    }
    
    func generateRandomNumber(numDigits: Int) -> String {
        
        var numString = ""
        for _ in 0...numDigits - 1 {
            let num = arc4random_uniform(10)
            numString += "\(num)"
            print("num: \(numString)")
        }
        
        return numString
    }
    
    func generateRoom() -> String {
        
        var roomNumber = ""
        var repeatedNum = true
        while(repeatedNum) {
            roomNumber = generateRandomNumber(numDigits: 6)
            repeatedNum = false
            for room in self.currentRooms {
                if roomNumber == room {
                    repeatedNum = true
                }
            }
        }
        
        let userNum = arc4random_uniform(24)
        
        //let takenUsers = [userNum : Int(userNum)]
        
        let passcode = generateRandomNumber(numDigits: 4)
        
        let roomData = [
            "passcode": passcode,
            "createdDate": FIRServerValue.timestamp(),
            ] as [String : Any]
        
        self.ds.roomRef.child(roomNumber).setValue(roomData)
        
        self.ds.addUserToRoom(uid: self.currentUser!, RoomId: roomNumber, userNum: "\(userNum)")
        
        return roomNumber
    }
    


}
