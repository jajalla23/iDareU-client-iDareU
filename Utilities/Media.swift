//
//  Media.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/11/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

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
