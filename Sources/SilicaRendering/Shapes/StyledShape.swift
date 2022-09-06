//
//  File.swift
//  
//
//  Created by Emory Dunn on 9/2/22.
//

import Foundation
import SwiftGraphics2
import Silica

extension StyledShape: SIDrawable {
	public func draw(in context: Silica.CGContext) {
		context.saveGState()

		if let strokeColor {
			context.strokeColor = CGColor(strokeColor)
		}

		if let strokeWidth {
			context.lineWidth = strokeWidth
		}

		if let fillColor {
			context.fillColor = CGColor(fillColor)
		}

		if let shape = shape as? SIDrawable {
			shape.draw(in: context)
		}


		context.restoreGState()
	}
}
