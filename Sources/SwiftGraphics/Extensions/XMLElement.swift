//
//  XMLElement.swift
//  
//
//  Created by Emory Dunn on 5/22/20.
//

import Foundation

extension XMLElement {
    
    /// Adds an attribute node to the receiver.
    /// - Parameters:
    ///   - value: The value to be converted into a string
    ///   - key: Name of the attribute
    func addAttribute(_ value: CustomStringConvertible, forKey key: String) {
        let attr = XMLNode(kind: .attribute)
        attr.name = key
        attr.stringValue = String(describing: value)
        
        addAttribute(attr)
    }
    
    /// Adds an attribute node to the receiver.
    /// - Parameters:
    ///   - value: The value to be converted into a string
    ///   - key: Name of the attribute
    func addAttribute(_ value: Color, forKey key: String) {
        let attr = XMLNode(kind: .attribute)
        attr.name = key
        attr.stringValue = value.toRGBA()
        
        addAttribute(attr)
    }
}
