//
//  myRoomsCell.swift
//  Masked
//
//  Created by Forest Plasencia on 2/16/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class myRoomsCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var roomNumLbl: UILabel!
    @IBOutlet weak var roomMemberLbl: UILabel!
    
    var name = ""

    
    func configureCell(roomNum: String, memberCount: Int, roomData: Dictionary<String, AnyObject>){
        
        if let name = roomData["roomName"] as? String {
            self.name = name
        }
        
        if (self.name != nil && self.name != "") {
            self.roomNumLbl.text = self.name
        } else {
            self.roomNumLbl.text = "Room \(roomNum)"
        }
        
        self.roomMemberLbl.text = "\(memberCount) Members"
        
    }

    
}
