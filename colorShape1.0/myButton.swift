//
//  myButton.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class myButton: UIButton {
    
    var path = UIBezierPath()
    var pathTag = Int()
    
    override func draw(_ rect: CGRect) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.path.cgPath
        self.layer.mask = shapeLayer
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let res = super.point(inside: point, with: event)
        
        if res{
            if self.path.contains(point){
                return self
            }
            return nil
        }
        
        /*
         guard self.bounds.contains(point) else { return nil }
         
         var displayedImage: UIImage?
         if let img = self.image(for: self.state) {
         displayedImage = img
         }else if let img = self.backgroundImage(for: self.state) {
         displayedImage = img
         } else {
         return nil
         }
         
         let x = (point.x / self.bounds.size.width) * displayedImage!.size.width
         let y = (point.y / self.bounds.size.height) * displayedImage!.size.height
         let scaledPoint = CGPoint(x: x, y: y)
         
         
         if displayedImage!.isPointTransparent(point: scaledPoint) {
         return nil
         }
         
         
         return self
         
         */
        return nil
    }
    
    
}
