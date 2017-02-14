//
//  mainVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import Firebase

class mainVC: UIViewController {

    @IBOutlet var mainView: UIView!
    
    var currentUser = ""
    
    var currentRooms = [String]()
    
    let createRoomSegue = "goToNewRoom"
    let joinRoomSegue = "goToJoinRoomVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ds = DataService.instance

        FIRAuth.auth()?.signInAnonymously(completion: { (user, err) in
            if err != nil {
                print("error user could not be created")
            } else {
                if let uid = user?.uid {
                    print("uid: \(uid)")
                    ds.userRef.child(uid).setValue("true")
                    self.currentUser = uid
                }
            }
        })
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            self.currentUser = uid
        }
        
        let view = mainView!
        let gradient = CAGradientLayer()
        
        let topColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let bottomColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)

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
        let ds = DataService.instance
        
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
        
        
        let passcode = generateRandomNumber(numDigits: 4)
        
        let roomData = [
            "passcode": passcode,
            "createdDate": FIRServerValue.timestamp(),
            ] as [String : Any]
        
        ds.roomRef.child(roomNumber).setValue(roomData)
        
        ds.addUserToRoom(uid: currentUser, RoomId: roomNumber)
        
        return roomNumber
    }
    
    @IBAction func createRoomPressed(_ sender: Any) {
        let ds = DataService.instance
        ds.roomRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let rooms = snapshot.value as? Dictionary<String, AnyObject> {
                for room in rooms {
                    self.currentRooms.append(room.key)
                    print(self.currentRooms)
                }
                
            }
            
            let roomId = self.generateRoom()
            self.performSegue(withIdentifier: self.createRoomSegue, sender: roomId)

        })
        
        
    }

    @IBAction func joinRoomPressed(_ sender: Any) {
        performSegue(withIdentifier: joinRoomSegue, sender: self.currentUser)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.createRoomSegue {
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as! String
            
        }
        
        if segue.identifier == self.joinRoomSegue {
            let joinRoomVC = (segue.destination as? joinRoomVC)
            joinRoomVC?.uid = sender as? String
            
        }
    }

}
