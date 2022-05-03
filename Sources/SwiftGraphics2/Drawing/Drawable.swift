//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/2/22.
//

import Foundation

/// Shapes that can be drawn on screen
public protocol Drawable {
    /// Color of the outline of the shape
    var strokeColor: Color?  { get set }
    
    /// Color of the fill of the shape
    var fillColor: Color? { get set }
    
    /// Weight of the outline of the shape
    var strokeWidth: Double? { get set }
}

public extension Drawable {
    func strokeColor(_ color: Color?) -> Self {
        var new = self
        new.strokeColor = color
        
        return new
    }
    
    func fillColor(_ color: Color?) -> Self {
        var new = self
        new.fillColor = color
        
        return new
    }
    
    func strokeWidth(_ weight: Double?) -> Self {
        var new = self
        new.strokeWidth = weight
        
        return new
    }
}

public extension Array where Element: Drawable {
    func strokeColor(_ color: Color?) -> Self {
        map { $0.strokeColor(color) }
    }
    
    func fillColor(_ color: Color?) -> Self {
        map { $0.fillColor(color) }
    }
    
    func strokeWidth(_ weight: Double?) -> Self {
        map { $0.strokeWidth(weight) }
    }
}
