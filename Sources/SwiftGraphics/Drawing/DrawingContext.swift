//
//  DrawingContext.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation



public class SwiftGraphicsContext {
    public static var current: DrawingContext?
}

public protocol DrawingContext {
    
}

extension CGContext: DrawingContext {
    
}
