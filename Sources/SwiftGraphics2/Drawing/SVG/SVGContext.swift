//
//  SVGContext.swift
//
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// A drawing context which creates SVG files
@resultBuilder
public class SVGContext {
    
    /// The root SVG element
    public var svg: XMLElement
    
    
    /// Width of the SVG
    public let width: Int
    
    
    /// Height of the SVG
    public let height: Int
    
    public var debug: Bool
    
    /// Create a new SVG with the specified dimensions
    /// - Parameters:
    ///   - width: Width of the SVG
    ///   - height: Height of the SVG
    public init(width: Int, height: Int, debug: Bool = false) {
        self.width = width
        self.height = height
        self.debug = debug
        

        // Set up the SVG root element
        self.svg = XMLElement(kind: .element)
        svg.name = "svg"
        svg.addAttribute(width, forKey: "width")
        svg.addAttribute(height, forKey: "height")
        svg.addAttribute("http://www.w3.org/2000/svg", forKey: "xmlns")
        svg.addAttribute("http://www.inkscape.org/namespaces/inkscape", forKey: "xmlns:inkscape")

        addBlendMode()

    }
    
    public init(width: Int, height: Int, debug: Bool = false, @SVGContext shapes: () -> [SVGDrawable] = { [] }) {
        self.width = width
        self.height = height
        self.debug = debug
        
//        self.sh
        

        // Set up the SVG root element
        self.svg = XMLElement(kind: .element)
        svg.name = "svg"
        svg.addAttribute(width, forKey: "width")
        svg.addAttribute(height, forKey: "height")
        svg.addAttribute("http://www.w3.org/2000/svg", forKey: "xmlns")
        svg.addAttribute("http://www.inkscape.org/namespaces/inkscape", forKey: "xmlns:inkscape")
        
        shapes().forEach { self.addShape($0) }

        addBlendMode()
        
        
    }
    
//    /// Create a new SVG from a `SketchView`
//    @available(*, deprecated, message: "Initialize with a Sketch, rather than SketchView.", renamed: "init(sketch:)")
//    public convenience init(sketch: SketchView) {
//        self.init(
//            width: Int(sketch.bounds.width),
//            height: Int(sketch.bounds.height)
//        )
//    }
//
//    /// Create a new SVG from a `Sketch`
//    public convenience init(sketch: Sketch) {
//        self.init(
//            width: Int(sketch.size.width),
//            height: Int(sketch.size.height)
//        )
//    }
    
    /// Append a shape to the SVG
    /// - Parameter shape: Shape to add
    public func addShape(_ shape: SVGDrawable) {
        if debug {
            svg.addChild(shape.debugSVG())
        } else {
            svg.addChild(shape.svgElement())
        }
    }
    
    public func addShapes(_ shapes: [SVGDrawable]) {
        shapes.forEach { addShape($0) }
    }
    
    public func addShapes(_ shapes: SVGDrawable...) {
        shapes.forEach { addShape($0) }
    }

    /// Group top-level elements by the specified attribute's value.
    ///
    /// This method is useful for generating plottable multi-color SVGs. By using `stroke` as the attribute
    /// all elements will be grouped by their stroke color for easy pen switching.
    ///
    /// - Parameter attributeName: Grouping attribute name
    public func groupElements(by attributeName: SVGAttribute) {
        guard let children = svg.children as? [XMLElement] else { return }

        let grouped: [String: [XMLElement]] = Dictionary(grouping: children) {
            $0.detach()
            return ($0.attribute(forName: attributeName.rawValue)?.stringValue) ?? ""
        }

        let xmlGroups: [XMLElement] = grouped.enumerated().compactMap { (index, arg) in

            let (key, value) = arg

            // Don't create empty groups
            guard !value.isEmpty else { return nil }

            let groupNode = XMLElement(name: "g")
            groupNode.addAttribute(key, forKey: "id")

            // Inkscape compatibility
            groupNode.addAttribute("layer", forKey: "inkscape:groupmode")
            groupNode.addAttribute("\(index + 1)-\(key)", forKey: "inkscape:label")

            groupNode.setChildren(value)
            return groupNode
        }

        svg.setChildren(xmlGroups)

    }

    /// Ungroup top-level elements.
    ///
    /// If a shape draws itself as a group this method can be used to break the
    /// group apart before calling `groupElements(by:)`.
    ///
    public func breakGroups() {
        guard let children = svg.children as? [XMLElement] else { return }

        var newChildren: [XMLNode] = []

        children.forEach { node in
            if node.name == "g" {
                let groupNodes = node.children ?? []

                groupNodes.forEach { $0.detach() }
                newChildren.append(contentsOf: groupNodes)
            } else {
                newChildren.append(node)
            }
        }

        svg.setChildren(newChildren)
    }
    
    /// Add a `style` element with the blend mode
    func addBlendMode() {
//        let blendMode = SwiftGraphicsContext.blendMode.rawValue
//        let style = """
//
//            line { mix-blend-mode: \(blendMode); }
//            circle { mix-blend-mode: \(blendMode); }
//            .vector { mix-blend-mode: \(blendMode); }
//
//        """
//        let styleElement = XMLElement(name: "style", stringValue: style)
//
//        svg.addChild(styleElement)
    }
    
    /// Create an SVG document
    /// - Returns: An `XMLDocument` representing the SVG
    public func makeDoc() -> XMLDocument {

        let doc = XMLDocument(kind: .document)

        doc.setRootElement(svg)
        doc.characterEncoding = "UTF-8"
        doc.isStandalone = false
        doc.documentContentKind = .xml
        doc.version = "1.0"

        return doc
    }

    /// Returns the string representation of the receiver as it would appear in an XML document,
    /// with one or more output options specified.
    ///
    /// The returned string includes the string representations of all children.
    ///
    /// - Parameter options: One or more enum constants identifying an output option;
    /// bit-OR multiple constants together.
    ///
    /// See [Constants](apple-reference-documentation://hs0Nn4fB4Z) for a list of
    /// valid constants for specifying output options.
    public func svgString(options: XMLNode.Options = [.documentTidyXML, .nodePrettyPrint]) -> String {
        let doc = makeDoc()

        return doc.xmlString(options: options)
    }

    /// Attempt to write the SVG to the specified location
    /// - Parameter url: URL of the location to write the SVG
    /// - Parameter options: One or more enum constants identifying an output option;
    /// bit-OR multiple constants together.
    ///
    /// See [Constants](apple-reference-documentation://hs0Nn4fB4Z) for a list of
    /// valid constants for specifying output options.
    /// - Throws: Errors related to writing the SVG to disk
    public func writeSVG(to url: URL, options: XMLNode.Options = [.documentTidyXML, .nodePrettyPrint]) throws {
        let svg = svgString()

        try svg.write(to: url, atomically: true, encoding: .utf8)
    }
    
    public func writeSVG(to path: String, options: XMLNode.Options = [.documentTidyXML, .nodePrettyPrint]) throws {
        try writeSVG(to: URL(fileURLWithPath: path))
    }

}

public extension SVGContext {
    static func buildBlock(_ shapes: SVGDrawable...) -> [SVGDrawable] {
        shapes
    }
}
