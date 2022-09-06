//
//  GroupDrawable.swift
//
//
//  Created by Emory Dunn on 9/2/22.
//

import Foundation
import SwiftGraphics2
import CoreGraphics

extension GroupDrawable: CGDrawable {
	public func draw(in context: CGContext) {
		for case let shape as CGDrawable in shapes {
			shape.draw(in: context)
		}
	}
}
