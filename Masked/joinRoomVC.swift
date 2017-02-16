//
//  joinRoomVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class joinRoomVC: UIViewController {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var roomNumField: UITextField!
    @IBOutlet weak var roomPassField: UITextField!
    
    let joinRoomSegue = "goToJoinedRoom"
    
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let view = mainView!
        let gradient = CAGradientLayer()
        
        let topColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let bottomColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

    }

    @IBAction func passwordJoinPressed(_ sender: Any) {
        self.tryToJoin()
    }
    
    @IBAction func roomJoinPressed(_ sender: Any) {
        self.tryToJoin()
    }
    @IBAction func joinPressed(_ sender: Any) {
        self.tryToJoin()
    }

    func generateUserNum(nums: [Int]) -> String{
        
        var numTaken = true
        var userNumString = ""
        while (numTaken) {
            let userNum = arc4random_uniform(24)
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
    
    func tryToJoin() {
        
        var roomNum = ""
        var roomPass = ""
        guard self.roomNumField.text != "" else {
            print("room num nil")
            return
        }
        
        
        let roomNumCharCount = (self.roomNumField.text?.characters.count)!
        guard roomNumCharCount == 6 else {
            print("room num not 6 chars")
            
            return
        }
        guard self.roomPassField.text != "" else {
            print("room pass nil")
            return
        }
        let roomPassCharCount = (self.roomPassField.text?.characters.count)!
        guard roomPassCharCount == 4 else {
            print("room pass not 4 chars")
            return
        }
        
        roomNum = self.roomNumField.text!
        roomPass = self.roomPassField.text!
        
        let ds = DataService.instance
        
        // Refactor into service

        ds.roomRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
            if let roomInfo = snapshot.value as? Dictionary<String, AnyObject> {
                if let pass = roomInfo[FIR_PASS_REF] as? String {
                    
                    ds.roomMemberRef.child(roomNum).observeSingleEvent(of: .value, with: { (snapshot) in
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
                                return
                            }
                            
                            if roomPass == pass {
                                // segue to room
                                if let userID = self.uid {
                                    ds.addUserToRoom(uid: userID, RoomId: roomNum, userNum: userNum)
                                    self.performSegue(withIdentifier: self.joinRoomSegue, sender: roomNum)
                                }
                                
                                
                            } else {
                                // invalid pass
                                
                            }
                        }

                    })
                    
                }
            }
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.joinRoomSegue {
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as! String
            
        }
    }
    
}
