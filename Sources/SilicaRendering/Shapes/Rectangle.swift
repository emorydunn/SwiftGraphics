//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/2/22.
//

import Foundation
import SwiftGraphics2
import Silica

extension Rectangle: SIDrawable {

	public func makeCGRect() -> CGRect {
		// Create the rectangle
		let transMatrix = MatrixTransformation.translate(vector: origin)
		let corner = Vector(-width / 2,  -height / 2, transformation: transMatrix)
		return CGRect(x: corner.x, y: corner.y, width: width, height: height)
	}

	public func draw(in context: Silica.CGContext) {

		let rect = makeCGRect()

		// Save the state and rotate
		context.saveGState()
		context.rotateBy(rotation.degrees)

		// Draw the rect
		context.addRect(rect)

		context.strokePath()
		context.fillPath()

		// Restore the state
		context.restoreGState()
	}
}
