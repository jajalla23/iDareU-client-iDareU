//
//  Extensions.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 9/28/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIView {

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }

}

extension UIImage {
    @objc func compressJPEGImage() -> Data {
        
        var actualHeight: CGFloat = self.size.height;
        var actualWidth: CGFloat = self.size.width;
        let maxHeight: CGFloat = 600.0;
        let maxWidth: CGFloat = 800.0;
        var imgRatio: CGFloat = actualWidth/actualHeight;
        let maxRatio: CGFloat = maxWidth/maxHeight;
        let compressionQuality : CGFloat = 0.5; //50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            } else if (imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            } else {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }

        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = UIImageJPEGRepresentation(img, compressionQuality)
        UIGraphicsEndImageContext();
        
        return imageData!
    }
}