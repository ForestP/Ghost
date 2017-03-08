//
//  UIAlertController+Ext.swift
//  Ghost
//
//  Created by Forest Plasencia on 3/7/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    func createAlertWith(message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
}
