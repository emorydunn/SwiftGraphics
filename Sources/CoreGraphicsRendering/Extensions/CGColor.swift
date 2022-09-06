//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 8/9/22.
//

import Foundation
import CoreGraphics
import SwiftGraphics2

public extension Color {
	var asCGColor: CGColor {
		CGColor(
			red: red,
			green: green,
			blue: blue,
			alpha: alpha
		)
	}
}
