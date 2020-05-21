//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public protocol CGDrawable {
    func draw(in context: CGContext)
    func debugDraw(in context: CGContext)
}
