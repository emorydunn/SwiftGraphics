//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/7/22.
//

import Foundation

public protocol DrawingContext {
    func addShape(_ shape: Drawable)
}
