//
//  NibLoadableView.swift
//  Masked
//
//  Created by Forest Plasencia on 2/14/17.
//  Copyright © 2017 Forest Plasencia. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
