//
//  roomNameVC.swift
//  Ghost
//
//  Created by Forest Plasencia on 3/7/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class roomNameVC: UIViewController {

    var roomId: String!
    let ds = DataService.instance
    
    @IBOutlet weak var roomNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        
        guard let name = roomNameField.text, !name.isEmpty else {
            // no nickname just segues
            self.dismiss(animated: true, completion: nil)

            return
        }
        
        guard name.characters.count < 15 else {
            // alert nickname too long
            let alert = UIAlertController().createAlertWith(message: "Room Name Exceeds 15 Characters")
            self.present(alert, animated: true, completion: nil)
        
            return
        }
        
        // passed guards add nickname to room
        ds.addRoomNickName(roomId: self.roomId, roomName: name)
        
        let presentingViewController: myRoomsVC! = self.presentingViewController as! myRoomsVC!

        self.dismiss(animated: true) { 
            presentingViewController.segueToChatRoom(roomNum: self.roomId)
        }
    }
    
    




}
