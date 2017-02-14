//
//  joinRoomVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

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
        print("num: \(roomNum)")
        ds.roomRef.child(roomNum).child(FIR_PASS_REF).observeSingleEvent(of: .value, with: { (snapshot) in
            if let pass = snapshot.value as? String {
                if roomPass == pass {
                    // segue to room
                    if let userID = self.uid {
                        ds.addUserToRoom(uid: userID, RoomId: roomNum)
                        self.performSegue(withIdentifier: self.joinRoomSegue, sender: roomNum)
                    }

                    
                } else {
                    // invalid pass
                    
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
