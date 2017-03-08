//
//  roomNameField.swift
//  Ghost
//
//  Created by Forest Plasencia on 3/7/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class roomNameField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let FIELD_BORDER = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        layer.borderWidth = 1
        layer.cornerRadius = 5.0
        
        layer.borderColor = FIELD_BORDER.cgColor
        
    }

}
