//
//  msgCell.swift
//  Masked
//
//  Created by Forest Plasencia on 2/14/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class msgCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var msgText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message){
        
        
        self.msgText.text = message.msgText
        let userNum = message.postedBy
        
        self.userIcon.image = UIImage(named: "icon\(userNum)")

        
    }
    
}
