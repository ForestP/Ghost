//
//  mainGradientView.swift
//  Masked
//
//  Created by Forest Plasencia on 2/13/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

class mainGradientView: UIView {

    override func awakeFromNib() {
        
        let view = self
        let gradient = CAGradientLayer()
        
        let topColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
        let bottomColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        gradient.frame = view.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }

}
