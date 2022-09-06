//
//  ImageRep.swift
//  
//
//  Created by Emory Dunn on 9/6/22.
//

import Foundation
import CoreGraphics
import AppKit

public extension NSBitmapImageRep.FileType {
	var fileExtension: String {
		switch self {
		case .tiff:
			return "tiff"
		case .bmp:
			return "bmp"
		case .gif:
			return "gif"
		case .jpeg:
			return "jpeg"
		case .png:
			return "png"
		case .jpeg2000:
			return "jpeg2000"
		@unknown default:
			fatalError("Unknown file format: \(self)")
		}
	}
}
