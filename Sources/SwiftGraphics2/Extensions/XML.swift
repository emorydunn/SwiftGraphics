//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation

extension XMLElement {

    /// Adds an attribute node to the receiver.
    /// - Parameters:
    ///   - value: The value to be converted into a string
    ///   - key: Name of the attribute
    public func addAttribute(_ value: CustomStringConvertible, forKey key: String) {
        let attr = XMLNode(kind: .attribute)
        attr.name = key
        attr.stringValue = String(describing: value)

        addAttribute(attr)
    }

}
