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
    
    let joinRoomSegue = "goToJoinedRoom"
    
    let jrs = JoinRoomService.instance
    
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
        
        
        
        // Refactor into service
        jrs.tryToJoin(roomNum: roomNum, roomPass: roomPass)
        
    }
    
    func joinRoomSuccessful(roomNum: String, userNum: String) {
        if let userID = self.uid {
            let ds = DataService.instance
            ds.addUserToRoom(uid: userID, RoomId: roomNum, userNum: userNum)
            self.performSegue(withIdentifier: self.joinRoomSegue, sender: roomNum)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.joinRoomSegue {
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as! String
            
        }
    }
    
}
