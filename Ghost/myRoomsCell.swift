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

    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
    }
    
    func configureCell(room: Room){
        
        let roomNum = room.roomId
        let memberCount = room.roomMembers
        let roomData = room.roomData
        
        if let name = roomData["roomName"] as? String {
            self.name = name
        }
        
        if (self.name != "") {
            self.roomNumLbl.text = self.name
        } else {
            self.roomNumLbl.text = "Room \(roomNum)"
        }
        
        self.roomMemberLbl.text = "\(memberCount) Members"
        
    }

    
}
