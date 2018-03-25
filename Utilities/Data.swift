//
//  Data.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/1/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public struct Queue<T>: ExpressibleByArrayLiteral {
    /// backing array store
    public private(set) var elements: Array<T> = []
    
    /// introduce a new element to the queue in O(1) time
    public mutating func push(value: T) { elements.append(value) }
    
    /// remove the front of the queue in O(`count` time
    public mutating func pop() -> T { return elements.removeFirst() }
    
    public mutating func peek() -> T { return elements.first! }
    
    /// test whether the queue is empty
    public var isEmpty: Bool { return elements.isEmpty }
    
    /// queue size, computed property
    public var count: Int { return elements.count }
    
    /// offer `ArrayLiteralConvertible` support
    public init(arrayLiteral elements: T...) { self.elements = elements }
    public init(elements: Array<T>) {
        self.elements = elements
    }
}

public class DateTime {
    public static func getCurrentDateTime() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        //let interval = date.timeIntervalSince1970
        return dateString
    }
}
