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

	public static func buildBlock(_ content: Emitter...) -> Emitter {
		if content.count == 1 {
			content[0]
		} else {
			EmitterGroup(content)
		}
	}

	public static func buildArray(_ content: [Emitter]) -> Emitter {
		EmitterGroup(content)
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

	public static func buildFinalResult(_ component: Emitter) -> [Emitter] {
		switch component {
		case let e as EmitterGroup:
			e.emitters
		default:
			[component]
		}
	}

}

public struct EmitterGroup: Emitter, CustomStringConvertible {
	let emitters: [Emitter]

	public var style: RayTraceStyle = .line

	public var description: String {
		"Emitter Group \(emitters.count)"
	}

	init(_ emitters: [Emitter]) {
		self.emitters = emitters
	}

	public mutating func run(objects: [any RayTracable], initialIndex: Double) {
		for var emitter in emitters {
			emitter.run(objects: objects, initialIndex: initialIndex)
		}
	}
}
