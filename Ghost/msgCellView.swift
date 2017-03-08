//
//  msgCellView.swift
//  Masked
//
//  Created by Forest Plasencia on 2/16/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class msgCellView: UIView {
    
    override func awakeFromNib() {
        
        let BORDER = 250/255
        
        // layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        // layer.shadowRadius = 1
        
        layer.cornerRadius = 10
        
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: (230/255), green: (230/255), blue: (230/255), alpha: 1).cgColor
        
    }
    
}
