//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 8/9/22.
//

import Foundation
import Silica

public extension CGColor {
    init(_ color: Color) {
        self.init(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
    }
}
