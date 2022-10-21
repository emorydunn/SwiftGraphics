//
//  ColorTests.swift
//  
//
//  Created by Emory Dunn on 10/20/22.
//

import XCTest
@testable import SwiftGraphics2

final class ColorTests: XCTestCase {

	// MARK: Integer Colors
	func testInit() {
		let color = Color(153, 102, 204)

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 1)
	}

	// MARK: Hex String
	func testInitHex() {
		let color = Color(hexString: "9966cc")

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 1)
	}

	func testInitHexAlpha() {
		let color = Color(hexString: "9966cccc")

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 0.8)
	}

	func testInitHexManualAlpha() {
		let color = Color(hexString: "9966cccc", alpha: 0.5)

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 0.5)
	}

	func testInitStringHex() {
		let color: Color = "#9966cc"

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 1)
	}

	// MARK: Color Components
	func testInitComponents_None() {
		let color = Color(fromComponents: [])

		XCTAssertEqual(color, Color.black)
	}

	func testInitComponents_Grey() {
		let color = Color(fromComponents: [
			0.42
		])

		XCTAssertEqual(color.red, 0.42)
		XCTAssertEqual(color.green, 0.42)
		XCTAssertEqual(color.blue, 0.42)
		XCTAssertEqual(color.alpha, 1)
		XCTAssertEqual(color.grey, 0.42)
	}

	func testInitComponents_GreyAlpha() {
		let color = Color(fromComponents: [
			0.42,
			0.5
		])

		XCTAssertEqual(color.red, 0.42)
		XCTAssertEqual(color.green, 0.42)
		XCTAssertEqual(color.blue, 0.42)
		XCTAssertEqual(color.alpha, 0.5)
		XCTAssertEqual(color.grey, 0.42)
	}

	func testInitComponents_RGB() {
		let color = Color(fromComponents: [
			0.42,
			0.5,
			0.8
		])

		XCTAssertEqual(color.red, 0.42)
		XCTAssertEqual(color.green, 0.5)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 1)
	}

	func testInitComponents_RGBAlpha() {
		let color = Color(fromComponents: [
			0.42,
			0.5,
			0.8,
			0.2
		])

		XCTAssertEqual(color.red, 0.42)
		XCTAssertEqual(color.green, 0.5)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 0.2)
	}

	func testInitComponents_OverOne() {
		let color = Color(fromComponents: [
			100,
			0.5,
			0.8,
			0.2
		])

		XCTAssertEqual(color.red, 1)
		XCTAssertEqual(color.green, 0.5)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 0.2)
	}

	func testInitStringRGB() {
		let color: Color = "rgb(0.6,0.4,0.8)"

		XCTAssertEqual(color.red, 0.6)
		XCTAssertEqual(color.green, 0.4)
		XCTAssertEqual(color.blue, 0.8)
		XCTAssertEqual(color.alpha, 1)
	}

	func testInitStringRGB_InvalidMatch() {
		let color: Color = "rgba 0.6,0.4,0.8"

		XCTAssertEqual(color, Color.black)
	}

	func testInitStringRGB_Empty() {
		let color: Color = "rgba(,)"

		XCTAssertEqual(color, Color.black)
	}

	// MARK: Names
	func testName() {
		XCTAssertNotNil(Color(name: "aliceblue"))
	}

	func testName_Invalid() {
		XCTAssertNil(Color(name: "someColor"))
	}

	func testStringName() {
		let color: Color = "aliceblue"

		XCTAssertEqual(color, Color.aliceblue)
	}

	func testStringName_Invalid() {
		let color: Color = "someColor"

		XCTAssertEqual(color, Color.black)
	}


}

@available(macOS 12.0, *)
final class ColorFormatTests: XCTestCase {

	func testHex() {
		let color = Color(153, 102, 204).formatted(.hex)

		XCTAssertEqual(color, "#9966CC")
	}

	func testHexAlpha() {
		let color = Color(153, 102, 204, 0.5).formatted(.hexAlpha)

		XCTAssertEqual(color, "#9966CC80")
	}

	func testRGBA() {
		let color = Color(153, 102, 204, 0.5).formatted(.rgba)

		XCTAssertEqual(color, "rgba(153,102,204,0.5)")
	}
}
