//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// A set of components that define a color. The color space is defined by the drawing context.
public struct Color: Equatable {
    
    /// Red value
    public let red: Float
    
    /// Green value
    public let green: Float
    
    /// Blue value
    public let blue: Float
    
    /// Alpha value
    public let alpha: Float

    /// Instantiate a new Color
    ///
    /// /// This method expects color values between `0` and `1`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.red = red.clamped(to: 0...1)
        self.green = green.clamped(to: 0...1)
        self.blue = blue.clamped(to: 0...1)
        self.alpha = alpha.clamped(to: 0...1)
    }

    /// Instantiate a new Color
    ///
    /// This method expects color values between `0` and `255`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Float = 1) {
        self.init(
            red: Float(red) / 255,
            green: Float(green) / 255,
            blue: Float(blue) / 255,
            alpha: alpha
        )
    }

    /// Create a grey
    /// - Parameters:
    ///   - grey: Decimal grey value
    ///   - a: Alpha value, from 0 to 1
    public init(grey: Float, _ alpha: Float = 1) {
        self.init(red: grey, green: grey, blue: grey, alpha: alpha)
    }

    /// Create  a color from a hex string
    /// From: https://stackoverflow.com/a/26341062
    public init(hexString: String) {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        self.alpha = 1.0
        self.red = Color.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        self.green = Color.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        self.blue = Color.colorComponentFrom(colorString: colorString, start: 4, length: 2)
    }

    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> Float {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat = Float(hexComponent)
        let floatValue = Float(hexFloat / 255.0)
        return floatValue
    }

    /// Convert to a hex string
    /// From: https://stackoverflow.com/a/26341062
    public func toHex() -> String {

        let r = lroundf(red * 255) // swiftlint:disable:this identifier_name
        let g = lroundf(green * 255) // swiftlint:disable:this identifier_name
        let b = lroundf(blue * 255) // swiftlint:disable:this identifier_name

        let hexString = String.init(format: "#%02lX%02lX%02lX", r, g, b)
        return hexString
    }
    
    /// Createa CGColor
    public func toCGColor() -> CGColor {
        return CGColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
    
    /// Returns an RGBA string
    public func toRGBA() -> String {
        let r = lroundf(red * 255) // swiftlint:disable:this identifier_name
        let g = lroundf(green * 255) // swiftlint:disable:this identifier_name
        let b = lroundf(blue * 255) // swiftlint:disable:this identifier_name

        return "rgba(\(r),\(g),\(b),\(alpha))"
    }
    
    /// The color black
    public static var black: Color { Color(red: 0, green: 0, blue: 0, alpha: 1) }
    
    /// The color white
    public static var white: Color { Color(red: 1, green: 1, blue: 1, alpha: 1) }
    
    /// A clear color
    public static var clear: Color { Color(red: 0, green: 0, blue: 0, alpha: 0) }

    /// The color red
    public static var red: Color { Color(red: 1, green: 0, blue: 0, alpha: 1) }
    
    /// The color green
    public static var green: Color { Color(red: 0, green: 1, blue: 0, alpha: 1) }
    
    /// The color blue
    public static var blue: Color { Color(red: 0, green: 0, blue: 1, alpha: 1) }

}
