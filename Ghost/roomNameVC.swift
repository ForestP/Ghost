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
    
    let finishCreateSeque = "goToChatRoom"
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.finishCreateSeque {
            let chatRoomVC = (segue.destination as? chatRoomVC)
            chatRoomVC?.roomId = sender as! String
        }
        

    }



}
