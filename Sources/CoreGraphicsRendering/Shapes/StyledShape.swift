//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/2/22.
//

import Foundation
import CoreGraphics
import SwiftGraphics2

extension StyledShape: CGDrawable {
	public func draw(in context: CGContext) {
		context.saveGState()

		if let strokeColor {
			context.setStrokeColor(red: strokeColor.red, green: strokeColor.green, blue: strokeColor.blue, alpha: strokeColor.alpha)
		}

		if let strokeWidth {
			context.setLineWidth(strokeWidth)
		}

		if let fillColor {
			context.setFillColor(red: fillColor.red, green: fillColor.green, blue: fillColor.blue, alpha: fillColor.alpha)
		}

		if let shape = shape as? CGDrawable {
			shape.draw(in: context)
		}

		context.restoreGState()
	}
}
