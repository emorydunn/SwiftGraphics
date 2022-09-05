//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/6/22.
//

import Foundation

public protocol Sketch {
    associatedtype Body: Drawable
    
    /// Size of the sketch
    var size: Size { get set }

	@SketchBuilder
	var body: Body { get }

}

public extension Sketch {
    
    /// Return a unique file name based on a hash of the time and pid.
    ///
    /// The string takes the form of `YYYYMMDD-HHmmss-<short hash>`
    func hashedFileName(dateFormat: String = "yyyyMMdd-HHmmss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        let dateString = formatter.string(from: Date())

        let hash = "\(getpid())-\(dateString)".sha1()
        let shortHash = String(hash.dropLast(hash.count - 8))

        let fileName = "\(dateString)-\(shortHash)"

        return fileName
    }
    
    func outputFolder(from path: String = #file) -> URL {
        var url = URL(fileURLWithPath: path).deletingLastPathComponent()

        while true {
            if isRootFolder(url) {
                return url.appendingPathComponent("Output")
            }
            url.deleteLastPathComponent()
        }

    }
    
    func isRootFolder(_ url: URL) -> Bool {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
            return false
        }
        
        return contents.contains { url in
            url.lastPathComponent == "Package.swift"
        }
    }

}

@resultBuilder
public struct SketchBuilder {

    public static func buildBlock() -> EmptyDrawable { EmptyDrawable() }
    
    public static func buildBlock<Content: Drawable>(_ content: Content) -> Content {
        content
    }

	public static func buildBlock<Content: Drawable>(_ content: () -> Content) -> Content {
		content()
	}

    public static func buildBlock(_ content: Drawable...) -> GroupDrawable {
        GroupDrawable(content)
    }
    
    public static func buildBlock<Content: Drawable>(_ content: Content...) -> [Content] {
        content
    }
    
    public static func buildArray(_ content: [Drawable]) -> GroupDrawable {
        GroupDrawable(content)
    }

	public static func buildArray(_ content: [Drawable]?) -> GroupDrawable {
		GroupDrawable(content ?? [])
	}

	public static func buildOptional(_ component: Drawable?) -> Drawable {
		return component ?? EmptyDrawable()
	}

}
