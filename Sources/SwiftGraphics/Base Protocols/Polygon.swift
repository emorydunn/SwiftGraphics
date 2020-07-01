//
//  Polygon.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represens a `Shape` that has an internal area
public protocol Polygon: Intersectable {
    
    func contains(_ point: Vector) -> Bool
    
    func rayIntersection(_ theta: Radians) -> Vector
}
