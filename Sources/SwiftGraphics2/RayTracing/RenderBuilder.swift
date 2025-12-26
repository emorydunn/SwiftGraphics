//
//  File.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//

import Foundation

public typealias RayDrawable = RayTracable & Drawable

@resultBuilder
public struct RenderBuilder {

	public static func buildBlock(_ components: RayDrawable...) -> [RayDrawable] {
		components
	}
}
