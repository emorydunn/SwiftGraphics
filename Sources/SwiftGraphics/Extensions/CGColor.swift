//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

extension CGColor {
    
    // Convert to a hex string
    // From: https://stackoverflow.com/a/26341062
    func toHex() -> String {
        
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        switch components?.count {
        case 4:
            /// RGB Colors
            r = components?[0] ?? 0.0
            g = components?[1] ?? 0.0
            b = components?[2] ?? 0.0
        default:
            // Greyscale colors
            r = components?[0] ?? 0.0
            g = components?[0] ?? 0.0
            b = components?[0] ?? 0.0
        }
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
