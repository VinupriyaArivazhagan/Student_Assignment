//
//  Extensions.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/11/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageViewBoundsAndBorder()
    {
        self.layer.borderWidth = 5.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
}
