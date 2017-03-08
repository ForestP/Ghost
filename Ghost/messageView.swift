//
//  messageView.swift
//  Masked
//
//  Created by Forest Plasencia on 2/14/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class messageView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.height / 2
        
    }

}
