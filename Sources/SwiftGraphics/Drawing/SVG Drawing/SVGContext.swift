//
//  SVGContext.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public class SVGContext: DrawingContext {
    
    public var svg: XMLElement
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        // Set up the SVG root element
        self.svg = XMLElement(kind: .element)
        svg.name = "svg"
        svg.addAttribute(width, forKey: "width")
        svg.addAttribute(height, forKey: "height")
        svg.addAttribute("http://www.w3.org/2000/svg", forKey: "xmlns")
        
        addBlendMode()
        
    }
    
    public convenience init(sketch: SketchView) {
        self.init(
            width: Int(sketch.bounds.width),
            height: Int(sketch.bounds.height)
        )
    }
    
    public convenience init(sketch: Sketch) {
        self.init(
            width: Int(sketch.size.width),
            height: Int(sketch.size.height)
        )
    }
    
    
    public func addShape(_ shape: SVGDrawable) {
        let xml = shape.svgElement()

        svg.addChild(xml)
    }
    
    public func groupElements(by attributeName: String) {
        guard let children = svg.children as? [XMLElement] else { return }
    
        let grouped: [String?: [XMLElement]] = Dictionary(grouping: children) {
            $0.detach()
            return $0.attribute(forName: attributeName)?.stringValue
        }
        
        let xmlGroups: [XMLElement] = grouped.map { (arg) in
            
            let (key, value) = arg
            
            let groupNode = XMLElement(name: "g")
            groupNode.addAttribute(key ?? "", forKey: "id")
            
            groupNode.setChildren(value)
            return groupNode
        }
        
        svg.setChildren(xmlGroups)
        
    }
    
    func addBlendMode() {
        let blendMode = SwiftGraphicsContext.blendMode.rawValue
        let style = """
        
            line { mix-blend-mode: \(blendMode); }
            circle { mix-blend-mode: \(blendMode); }
            .vector { mix-blend-mode: \(blendMode); }
            
        """
        let styleElement = XMLElement(name: "style", stringValue: style)
        
        svg.addChild(styleElement)
    }
    
    public func makeDoc() -> XMLDocument {

        let doc = XMLDocument(kind: .document)
        
        doc.setRootElement(svg)
        doc.characterEncoding = "UTF-8"
        doc.isStandalone = false
        doc.documentContentKind = .xml
        doc.version = "1.0"

        return doc
    }
    
    /// Returns the string representation of the receiver as it would appear in an XML document, with one or more output options specified.
    ///
    /// The returned string includes the string representations of all children.
    ///
    /// - Parameter options: One or more enum constants identifying an output option; bit-OR multiple constants together.
    /// See [Constants](apple-reference-documentation://hs0Nn4fB4Z) for a list of valid constants for specifying output options.
    public func svgString(options: XMLNode.Options = [.documentTidyXML, .nodePrettyPrint]) -> String {
        let doc = makeDoc()
        
        return doc.xmlString(options: options)
    }
    
    /// Attempt to write the SVG to the specified location
    /// - Parameter url: URL of the location to write the SVG
    /// - Parameter options: One or more enum constants identifying an output option; bit-OR multiple constants together.
    /// See [Constants](apple-reference-documentation://hs0Nn4fB4Z) for a list of valid constants for specifying output options.
    /// - Throws: Errors related to writing the SVG to disk
    public func writeSVG(to url: URL, options: XMLNode.Options = [.documentTidyXML, .nodePrettyPrint]) throws {
        let svg = svgString()
        
        try svg.write(to: url, atomically: true, encoding: .utf8)
    }

}

