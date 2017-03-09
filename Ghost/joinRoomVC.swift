//
//  joinRoomVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class joinRoomVC: UIViewController, JoinRoomServiceDelegate {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var roomNumField: UITextField!
    @IBOutlet weak var roomPassField: UITextField!
    
    let jrs = JoinRoomService.instance
    
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        self.jrs.delegate = self
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

    @IBAction func closeJoinRoomPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tryToJoin() {
        
        var roomNum = ""
        var roomPass = ""
        guard self.roomNumField.text != "" else {
            print("room num nil")
            let alert = UIAlertController().createAlertWith(message: "Invalid Room Number")
            self.present(alert, animated: true, completion: nil)
            return
        }
        let roomNumCharCount = (self.roomNumField.text?.characters.count)!
        guard roomNumCharCount == 6 else {
            print("room num not 6 chars")
            let alert = UIAlertController().createAlertWith(message: "Invalid Room Number")
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard self.roomPassField.text != "" else {
            print("room pass nil")
            let alert = UIAlertController().createAlertWith(message: "Invalid Room Password")
            self.present(alert, animated: true, completion: nil)
            return
        }
        let roomPassCharCount = (self.roomPassField.text?.characters.count)!
        guard roomPassCharCount == 4 else {
            print("room pass not 4 chars")
            let alert = UIAlertController().createAlertWith(message: "Invalid Room Password")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        roomNum = self.roomNumField.text!
        roomPass = self.roomPassField.text!
        
        
        jrs.tryToJoin(roomNum: roomNum, roomPass: roomPass)
        
    }
    
    func joinRoomSuccessful(roomNum: String, userNum: String) {
        if let userID = self.uid {
            let ds = DataService.instance
            ds.addUserToRoom(uid: userID, RoomId: roomNum, userNum: userNum)
            
            let presentingViewController: myRoomsVC! = self.presentingViewController as! myRoomsVC!
            
            self.dismiss(animated: true) {
                presentingViewController.segueToChatRoom(roomNum: roomNum)
            }
        }
    }
    
    func invalidPass() {
        let alert = UIAlertController().createAlertWith(message: "Invalid Room Num / Password combination")
        self.present(alert, animated: true, completion: nil)
    }
    
    func roomFull() {
        let alert = UIAlertController().createAlertWith(message: "Could not join, room already full")
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
