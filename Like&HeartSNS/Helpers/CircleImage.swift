//
//  CircleImage.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import UIKit

class CircleImage: UIImageView {
    
    @IBInspectable var borderWidth:CGFloat = 4
    @IBInspectable var borderColor:UIColor = UIColor.black
    
    override var image: UIImage? {
        
        willSet{
            layer.masksToBounds = false
            layer.cornerRadius = frame.height/2
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            clipsToBounds = true
            
            
        }
    }
}
