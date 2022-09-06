//
//  GroupDrawable.swift
//  
//
//  Created by Emory Dunn on 9/2/22.
//

import Foundation
import SwiftGraphics2
import Silica

extension GroupDrawable: SIDrawable {
	public func draw(in context: CGContext) {
		for case let shape as SIDrawable in shapes {
			shape.draw(in: context)
		}
	}
}
