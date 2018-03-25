//
//  Media.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/11/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit

public class MediaUtilities {
    public static func photoDataToFormData(data:Data, boundary:String, fileName:String) -> Data {
        var fullData = Data()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        //log(lineTwo)
        fullData.append(lineTwo.data(using: String.Encoding.utf8, allowLossyConversion: false)!)

        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 4
        fullData.append(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        return fullData
    }
}

class ImageGenerator: NSObject {
    class func imageWith(name: String?) -> UIImage? {
        return self.imageWith(name: name, width: 40, height: 40)
    }
    
    class func imageWith(name: String?, width: Int, height: Int) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    class func imageWith(string: String?, width: Int, height: Int, numOfLines: Int) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = numOfLines
        label.text = string
        
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            label.layer.render(in: currentContext)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
