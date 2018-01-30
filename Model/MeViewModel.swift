//
//  Objects.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/6/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public struct MeSections {
    var name: String
    var collapsed: Bool
    var numberOfRows: Int
    
    
    public init(name: String, collapsed: Bool = false, numOfRows: Int) {
        self.name = name
        self.collapsed = collapsed
        self.numberOfRows = numOfRows
    }
}
