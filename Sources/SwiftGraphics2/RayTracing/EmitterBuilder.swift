//
//  SketchBuilder.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//


@resultBuilder
public struct EmitterBuilder {

	public static func buildBlock() -> EmptyDrawable { EmptyDrawable() }

	public static func buildBlock<Content: Emitter>(_ content: Content) -> Content {
		content
	}

	public static func buildBlock<Content: Emitter>(_ content: () -> Content) -> Content {
		content()
	}

	public static func buildBlock(_ content: Emitter...) -> [Emitter] {
		content
	}

	public static func buildBlock<Content: Emitter>(_ content: Content...) -> [Content] {
		content
	}

	public static func buildArray(_ content: [Emitter]) -> [Emitter] {
		content
	}

	public static func buildOptional(_ component: Emitter?) -> Emitter? {
		component
	}

	public static func buildEither(first component: Emitter) -> Emitter {
		component
	}

	public static func buildEither(second component: Emitter) -> Emitter {
		component
	}

}
