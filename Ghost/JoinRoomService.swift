//
//  JoinRoomService.swift
//  Ghost
//
//  Created by Forest Plasencia on 3/7/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import Foundation
import UIKit

protocol JoinRoomServiceDelegate: class {
    func joinRoomSuccessful(roomNum: String, userNum: String)
    func roomFull()
    func invalidPass()
}

class JoinRoomService {
    private static let _instance = JoinRoomService()
    
    weak var delegate: JoinRoomServiceDelegate?
    
    static var instance: JoinRoomService {
        return _instance
    }
    
    let ds = DataService.instance
    
    func generateUserNum(nums: [Int]) -> String{
        var numTaken = true
        var userNumString = ""
        while (numTaken) {
            let userNum = arc4random_uniform(UInt32(MAX_ROOM_USERS))
            for num in nums {
                if Int(userNum) == num {
                    break
                } else {
                    numTaken = false
                    userNumString = "\(userNum)"
                }
            }
        }
        return userNumString
    }
    
    func tryToJoin(roomNum: String, roomPass: String) {
        ds.roomRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
            if let roomInfo = snapshot.value as? Dictionary<String, AnyObject> {
                if let pass = roomInfo[FIR_PASS_REF] as? String {
                    
                    self.ds.roomMemberRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
                        print(snapshot)
                        if let takenNums = snapshot.value as? [String: String] {
                            var userNums = USER_NUMS
                            for num in takenNums {
                                print(num)
                                userNums.remove(at: Int(num.value)!)
                            }
                            
                            let userNum = self.generateUserNum(nums: userNums)
                            print("num: \(userNum)")
                            
                            guard userNum != "" else {
                                print("room full")
                                self.delegate?.roomFull()
                                return
                            }
                            
                            if roomPass == pass {
                                // segue to room
                                self.delegate?.joinRoomSuccessful(roomNum: roomNum, userNum: userNum)
                                
                            } else {
                                // invalid pass
                                self.delegate?.invalidPass()
                            }
                        }
                        
                    })
                    
                }
            }
        })
    }
}
