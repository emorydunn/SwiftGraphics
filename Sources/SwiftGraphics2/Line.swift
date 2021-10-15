//
//  Line.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

public struct Line {
    /// The starting point of the line
    public var start: Vector

    /// The ending point of the line
    public var end: Vector
    
    public var length: Double { end.dist(start) }
}
