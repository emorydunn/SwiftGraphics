//
//  LineCap.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 12/17/25.
//

import Foundation
import CoreGraphics

public enum LineCap {
	case butt, round, square

	func toCGLineCap() -> CGLineCap {
		switch self {
		case .butt: return .butt
		case .round: return .round
		case .square: return .square
		}
	}
}
