//
//  RoomInfoBox.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class RoomInfoBox: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let BOX_BORDER = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        layer.borderWidth = 1
        layer.cornerRadius = 5.0
        
        layer.borderColor = BOX_BORDER.cgColor
        
    }

}
