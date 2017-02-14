//
//  roomButton.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class roomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let BTN_BORDER = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        layer.borderWidth = 1
        layer.cornerRadius = 5.0
        
        layer.borderColor = BTN_BORDER.cgColor
        
    }

}
