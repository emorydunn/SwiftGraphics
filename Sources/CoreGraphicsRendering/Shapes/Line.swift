//
//  Line.swift
//  
//
//  Created by Emory Dunn on 1/31/23.
//

import Foundation
import CoreGraphics
import SwiftGraphics2

extension Line: CGDrawable {
	public func draw(in context: CGContext) {

		// Draw the line
		context.move(to: CGPoint(x: start.x, y: start.y))
		context.addLine(to: CGPoint(x: end.x, y: end.y))

		context.strokePath()
	}
}
