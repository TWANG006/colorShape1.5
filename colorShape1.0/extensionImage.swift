//
//  extensionImage.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

extension UIImage {
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x:0.0, y:0.0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
