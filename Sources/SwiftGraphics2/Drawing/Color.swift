//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
//import Silica

/// A set of components that define a color. The color space is defined by the drawing context.
public struct Color: Sendable, Equatable, Hashable, Codable {
    
    /// Red value
    public let red: Double
    
    /// Green value
    public let green: Double
    
    /// Blue value
    public let blue: Double
    
    /// Alpha value
    public let alpha: Double
    
    /// The grey value of the color, determined by averaging the channels.
    public var grey: Double {
        return (red + green + blue) / 3
    }

    /// Instantiate a new Color
    ///
    /// /// This method expects color values between `0` and `1`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
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
    public init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double = 1) {
        self.init(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            alpha: alpha
        )
    }

    /// Create a grey
    /// - Parameters:
    ///   - grey: Decimal grey value
    ///   - a: Alpha value, from 0 to 1
    public init(grey: Double, _ alpha: Double = 1) {
        self.init(red: grey, green: grey, blue: grey, alpha: alpha)
    }

    /// Create  a color from a hex string
    /// From: https://stackoverflow.com/a/26341062
    public init(hexString: String, alpha: Double) {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "")

        self.alpha = alpha
        self.red = Color.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        self.green = Color.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        self.blue = Color.colorComponentFrom(colorString: colorString, start: 4, length: 2)
    }

	/// Create  a color from a hex string
	/// From: https://stackoverflow.com/a/26341062
	public init(hexString: String) {
		var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		colorString = colorString.replacingOccurrences(of: "#", with: "")

		self.red = Color.colorComponentFrom(colorString: colorString, start: 0, length: 2)
		self.green = Color.colorComponentFrom(colorString: colorString, start: 2, length: 2)
		self.blue = Color.colorComponentFrom(colorString: colorString, start: 4, length: 2)

		if colorString.count == 8 {
			self.alpha = Color.colorComponentFrom(colorString: colorString, start: 6, length: 2)
		} else {
			self.alpha = 1
		}
	}

	/// Create a Color from the specified color components.
	///
	/// Depending on the number of components given either a greyscale or RGB color will be initialized.
	///
	/// | Count | Colorspace | Alpha          |
	/// | ----- | ---------- | -------------- |
	/// | 1     | Greyscale  | 1              |
	/// | 2     | Greyscale  | last component |
	/// | 3     | RGB        | 1              |
	/// | 4     | RGB        | last component |
	///
	/// - Parameter components: The color components.
	public init(fromComponents components: [Double]) {
		switch components.count {
			case 0:
				// No components given, default to black
				self = Color.black
			case 1: // Greyscale Colorspace
				self.init(grey: components[0], 1)
			case 2: // Greyscale Colorspace
				self.init(grey: components[0], components[1])
			case 3:
				self.init(red: components[0],
								 green: components[1],
								 blue: components[2],
								 alpha: 1)
			case 4:
				self.init(red: components[0],
									 green: components[1],
									 blue: components[2],
									 alpha: components[3])
			default:
				// Extra components given, just grab the first four
				self.init(red: components[0],
								 green: components[1],
								 blue: components[2],
								 alpha: components[3])

		}
	}
    
    /// Determine the float value of a color component from it's hex representation in a string
    /// - Parameters:
    ///   - colorString: The full hex color value
    ///   - start: The starting position of the component value
    ///   - length: The length of the component value
    /// - Returns: The floating point value of the color component
    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> Double {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0


        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat = Double(hexComponent)
        let floatValue = Double(hexFloat / 255.0)
        return floatValue
    }

	@available(macOS, deprecated: 12.0, message: "Use .formatted(.hex)")
    /// Convert to a hex string
    /// From: https://stackoverflow.com/a/26341062
    public func toHex() -> String {
        let r = lround(red * 255) // swiftlint:disable:this identifier_name
        let g = lround(green * 255) // swiftlint:disable:this identifier_name
        let b = lround(blue * 255) // swiftlint:disable:this identifier_name

        let hexString = String.init(format: "#%02lX%02lX%02lX", r, g, b)
        return hexString
    }

	@available(macOS, deprecated: 12.0, message: "Use .formatted(.rgba)")
    /// Returns an RGBA string
    public func toRGBA() -> String {
        let r = lround(red * 255) // swiftlint:disable:this identifier_name
        let g = lround(green * 255) // swiftlint:disable:this identifier_name
        let b = lround(blue * 255) // swiftlint:disable:this identifier_name

        return "rgba(\(r),\(g),\(b),\(alpha))"
    }

	/// Return the color without transparency. 
	public var withoutAlpha: Color {
		Color(red: red, green: green, blue: blue)
	}

	public func withAlpha(_ alpha: Double) -> Color {
		Color(red: red, green: green, blue: blue, alpha: alpha)
	}
}
