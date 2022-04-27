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
    public func addAttribute(_ value: CustomStringConvertible, forKey key: String) {
        let attr = XMLNode(kind: .attribute)
        attr.name = key
        attr.stringValue = String(describing: value)

        addAttribute(attr)
    }

//    /// Adds an attribute node to the receiver.
//    /// - Parameters:
//    ///   - value: The value to be converted into a string
//    ///   - key: Name of the attribute
//    public func addAttribute(_ value: Color, forKey key: String) {
//        let attr = XMLNode(kind: .attribute)
//        attr.name = key
//        attr.stringValue = value.toHex()
//
//        addAttribute(attr)
//        
//        let alpha = XMLNode(kind: .attribute)
//        alpha.name = "\(key)-opacity"
//        alpha.stringValue = String(describing: value.alpha)
//        
//        addAttribute(alpha)
//    }
}

/// SVG attribute names.
///
/// See Mozilla's [reference](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute) for more info.
public enum SVGAttribute: String {
    case accentHeight = "accent-height"
    case accumulate
    case additive
    case alignmentBaseline = "alignment-baseline"
    case alphabetic
    case amplitude
    case arabicForm = "arabic-form"
    case ascent
    case attributeName
    case attributeType
    case azimuth
    case baseFrequency
    case baselineShift = "baseline-shift"
    case baseProfile
    case bbox
    case begin
    case bias
    case by
    case calcMode
    case capHeight = "cap-height"
    case `class`
    case clip
    case clipPathUnits
    case clipPath = "clip-path"
    case clipRule = "clip-rule"
    case color
    case colorInterpolation = "color-interpolation"
    case colorInterpolationFilters = "color-interpolation-filters"
    case colorProfile = "color-profile"
    case colorRendering = "color-rendering"
    case contentScriptType
    case contentStyleType
    case crossorigin
    case cursor
    case cx
    case cy
    case d
    case decelerate
    case descent
    case diffuseConstant
    case direction
    case display
    case divisor
    case dominantBaseline = "dominant-baseline"
    case dur
    case dx
    case dy
    case edgeMode
    case elevation
    case enableBackground = "enable-background"
    case end
    case exponent
    case externalResourcesRequired
    case fill
    case fillOpacity = "fill-opacity"
    case fillRule = "fill-rule"
    case filter
    case filterRes
    case filterUnits
    case floodColor = "flood-color"
    case floodOpacity = "flood-opacity"
    case fontFamily = "font-family"
    case fontSize = "font-size"
    case fontSizeAdjust = "font-size-adjust"
    case fontStretch = "font-stretch"
    case fontStyle = "font-style"
    case fontVariant = "font-variant"
    case fontWeight = "font-weight"
    case format
    case from
    case fr
    case fx
    case fy
    case g1
    case g2
    case glyphName = "glyph-name"
    case glyphOrientationHorizontal = "glyph-orientation-horizontal"
    case glyphOrientationVertical = "glyph-orientation-vertical"
    case glyphRef
    case gradientTransform
    case gradientUnits
    case hanging
    case height
    case href
    case hreflang
    case horizAdvX = "horiz-adv-x"
    case horizOriginX = "horiz-origin-x"
    case id
    case ideographic
    case imageRendering = "image-rendering"
    case `in`
    case in2
    case intercept
    case k
    case k1
    case k2
    case k3
    case k4
    case kernelMatrix
    case kernelUnitLength
    case kerning
    case keyPoints
    case keySplines
    case keyTimes
    case lang
    case lengthAdjust
    case letterSpacing = "letter-spacing"
    case lightingColor = "lighting-color"
    case limitingConeAngle
    case local
    case markerEnd = "marker-end"
    case markerMid = "marker-mid"
    case markerStart = "marker-start"
    case markerHeight
    case markerUnits
    case markerWidth
    case mask
    case maskContentUnits
    case maskUnits
    case mathematical
    case max
    case media
    case method
    case min
    case mode
    case name
    case numOctaves
    case offset
    case opacity
    case `operator`
    case order
    case orient
    case orientation
    case origin
    case overflow
    case overlinePosition = "overline-position"
    case overlineThickness = "overline-thickness"
    case panose1 = "panose-1"
    case paintOrder = "paint-order"
    case path
    case pathLength
    case patternContentUnits
    case patternTransform
    case patternUnits
    case ping
    case pointerEvents = "pointer-events"
    case points
    case pointsAtX
    case pointsAtY
    case pointsAtZ
    case preserveAlpha
    case preserveAspectRatio
    case primitiveUnits
    case r
    case radius
    case referrerPolicy
    case refX
    case refY
    case rel
    case renderingIntent = "rendering-intent"
    case repeatCount
    case repeatDur
    case requiredExtensions
    case requiredFeatures
    case restart
    case result
    case rotate
    case rx
    case ry
    case scale
    case seed
    case shapeRendering = "shape-rendering"
    case slope
    case spacing
    case specularConstant
    case specularExponent
    case speed
    case spreadMethod
    case startOffset
    case stdDeviation
    case stemh
    case stemv
    case stitchTiles
    case stopColor = "stop-color"
    case stopOpacity = "stop-opacity"
    case strikethroughPosition = "strikethrough-position"
    case strikethroughThickness = "strikethrough-thickness"
    case string
    case stroke
    case strokeDasharray = "stroke-dasharray"
    case strokeDashoffset = "stroke-dashoffset"
    case strokeLinecap = "stroke-linecap"
    case strokeLinejoin = "stroke-linejoin"
    case strokeMiterlimit = "stroke-miterlimit"
    case strokeOpacity = "stroke-opacity"
    case strokeWidth = "stroke-width"
    case style
    case surfaceScale
    case systemLanguage
    case tabindex
    case tableValues
    case target
    case targetX
    case targetY
    case textAnchor = "text-anchor"
    case textDecoration = "text-decoration"
    case textRendering = "text-rendering"
    case textLength
    case to
    case transform
    case transformOrigin = "transform-origin"
    case type
    case u1
    case u2
    case underlinePosition = "underline-position"
    case underlineThickness = "underline-thickness"
    case unicode
    case unicodeBidi = "unicode-bidi"
    case unicodeRange = "unicode-range"
    case unitsPerEm = "units-per-em"
    case vAlphabetic = "v-alphabetic"
    case vHanging = "v-hanging"
    case vIdeographic = "v-ideographic"
    case vMathematical = "v-mathematical"
    case values
    case vectorEffect = "vector-effect"
    case version
    case vertAdvY = "vert-adv-y"
    case vertOriginX = "vert-origin-x"
    case vertOriginY = "vert-origin-y"
    case viewBox
    case viewTarget
    case visibility
    case width
    case widths
    case wordSpacing = "word-spacing"
    case writingMode = "writing-mode"
    case x
    case xHeight = "x-height"
    case x1
    case x2
    case xChannelSelector
    case xlinkActuate = "xlink:actuate"
    case xlinkArcrole = "xlink:arcrole"
    case xlinkHref = "xlink:href"
    case xlinkRole = "xlink:role"
    case xlinkShow = "xlink:show"
    case xlinkTitle = "xlink:title"
    case xlinkType = "xlink:type"
    case xmlBase = "xml:base"
    case xmlLang = "xml:lang"
    case xmlSpace = "xml:space"
    case y
    case y1
    case y2
    case yChannelSelector
    case z
    case zoomAndPan
    
}
