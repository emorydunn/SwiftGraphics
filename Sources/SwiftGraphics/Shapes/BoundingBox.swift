//
//  BoundingBox.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation


/// A specialized `Rectangle` which is inset from the canvas size
public class BoundingBox: Rectangle {
    public var inset: Double
    
    enum CodingKeys: String, CodingKey {
        case inset
    }
    
    /// Instantiate a new `BoundingBox`
    /// - Parameter inset: Margin from the edge
    public init(inset: Double = 100) {
        self.inset = inset
        super.init(x: 0, y: 0, width: 0, height: 0)
        
        update()
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.inset = try container.decode(Double.self, forKey: .inset)
        
        try super.init(from: decoder)
        
    }
    
    /// Update the size of the rectangle based on the current context
    func update() {
        
        let contextWidth: Double
        let contextHeight: Double
        
        switch SketchContext.context {
        case let c as CGContext:
            //            draw(in: c)
            contextWidth = Double(c.width)
            contextHeight = Double(c.height)
        case let c as SVGContext:
            contextWidth = Double(c.width)
            contextHeight = Double(c.height)
        default:
            return
        }
        
        self.x = inset
        self.y = inset
        self.width = contextWidth / 2 - inset * 2
        self.height = contextHeight / 2 - inset * 2
    }
}
