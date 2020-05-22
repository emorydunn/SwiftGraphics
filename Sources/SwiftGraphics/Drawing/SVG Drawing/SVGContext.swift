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
        
        // Transform the shapes into XML elements and add them to the root
        //        let nodes = shapes.map {
        //            $0.svgElement()
        //        }
        //        svgRoot.setChildren(nodes)
        
//        self.svg = XMLDocument(kind: .document)
//        svg.setRootElement(svgRoot)
//        svg.characterEncoding = "UTF-8"
//        svg.isStandalone = false
//        svg.documentContentKind = .xml
//        svg.version = "1.0"
    }
    
    public convenience init(sketch: SketchView) {
        self.init(
            width: Int(sketch.bounds.width),
            height: Int(sketch.bounds.height)
        )
    }
    
    
    public func addShape(_ shape: SVGDrawable) {
        let xml = shape.svgElement()
        
        svg.addChild(xml)
//        shapes.append(shape)
    }
    
    public func makeDoc() -> XMLDocument {
//
        
//        svg.setChildren(nodes)

        let doc = XMLDocument(kind: .document)
        doc.setRootElement(svg)
        doc.characterEncoding = "UTF-8"
        doc.isStandalone = false
        doc.documentContentKind = .xml
        doc.version = "1.0"

        return doc
    }
//
}

