//
//  roomInfoVC.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class roomInfoVC: UIViewController {

    @IBOutlet weak var roomNumLbl: UILabel!
    @IBOutlet weak var roomPassLbl: UILabel!
    
    var roomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ds = DataService.instance
        
        if let id = roomId {
            ds.roomRef.child(id).child("passcode").observeSingleEvent(of: .value, with: { (snapshot) in
                if let passcode = snapshot.value as? String {
                    self.roomNumLbl.text = "Room: \(id)"
                    self.roomPassLbl.text = "Password: \(passcode)"
                }
                
            })
        }
       
    }

    @IBAction func closeRoomInfoPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
