//
//  Rectangle.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A rectangle
open class Rectangle: Polygon, CGDrawable, SVGDrawable {
    
    /// Origin X coordinate
    public var x: Double
    
    /// Origin Y coordinate
    public var y: Double
    
    /// Width of the rectangle
    public var width: Double
    
    /// Height of the rectangle
    public var height: Double
    
    /// Instantiate a new `Rectangle`
    /// - Parameters:
    ///   - x: Origin X coordinate
    ///   - y: Origin Y coordinate
    ///   - width: Width of the rectangle
    ///   - height: Height of the rectangle
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public var boundingBox: Rectangle { self }
    
    /// Returns the coordinates of the center of the Rectangle
    public var center: Vector {
        get {
            Vector(self.x + width / 2, self.y + height / 2)
        }
        set {
            self.x = newValue.x - width / 2
            self.y = newValue.y - height / 2
        }
    }
    
    /// A `Line` representing the top edge
    public var topEdge: Line {
        Line(topLeft, topRight)
    }

    /// A `Line` representing the bottom edge
    public var bottomEdge: Line {
        Line(bottomLeft, bottomRight)
    }

    /// A `Line` representing the left edge
    public var leftEdge: Line {
        Line(topLeft, bottomLeft)
    }

    /// A `Line` representing the right edge
    public var rightEdge: Line {
        Line(topRight, bottomRight)
    }
    
    /// Coordinate of the top-left corner
    public var topLeft: Vector {
        Vector(center.x + width / 2,
               center.y + height / 2)
    }
    
    /// Coordinate of the top-right corner
    public var topRight: Vector {
        Vector(center.x - width / 2,
               center.y + height / 2)
    }
    
    /// Coordinate of the bottom-left corner
    public var bottomLeft: Vector {
        Vector(center.x + width / 2,
               center.y - height / 2)
    }
    
    /// Coordinate of the botom-left corner
    public var bottomRight: Vector {
        Vector(center.x - width / 2,
               center.y - height / 2)
    }
    
    /// Shift a point to have coordinates relative to the rectangle
    /// - Parameter point: Point to shift
    func relativePoint(_ point: Vector) -> Vector {
        let relX = point.x - center.x
        let relY = point.y - center.y
        
        return Vector(relX, relY)
    }
    
    /// Undo the shift of a point to have coordinates relative to the rectangle
    /// - Parameter point: Point to shift
    func reverseRelativePoint(_ point: Vector) -> Vector {
        let relX = point.x + center.x
        let relY = point.y + center.y
        
        return Vector(relX, relY)
    }
    
    
    /// Returns the point on the rectangle where the specified angle originating from the center intersects
    /// - Parameter theta: Angle in radians
    public func rayIntersection(_ theta: Radians) -> Vector {
        return rayIntersection(origin: self.center, theta: theta)!

    }
    
    
    /// Returns a point on the rectangle at the specified angle from the given point
    ///
    /// From: https://math.stackexchange.com/a/717699
    /// - Parameters:
    ///   - point: Point of origin for the angle
    ///   - theta: Angle
    public func rayIntersection(origin point: Vector, theta: Radians) -> Vector? {
        let relPoint = relativePoint(point)

        if (theta == 0) {
            relPoint.x = width / 2
            let point = reverseRelativePoint(relPoint)

            return point
        }

        let halfWidth = width / 2
        let halfHeight = height / 2

        let t1 = (halfWidth - relPoint.x) / cos(theta)
        let t2 = (-halfWidth - relPoint.x) / cos(theta)
        let t3 = (halfHeight - relPoint.y) / sin(theta)
        let t4 = (-halfHeight - relPoint.y) / sin(theta)

        var options = [t1, t2, t3, t4]

        options = options.filter { $0 > 0 }
        options.sort()
        
        guard options.count > 0 else {
//            print("Could not find intersection for \(theta.toDegrees())")
            return nil
        }

        // console.log(options)
        let t5 = options[0]
        relPoint.x = relPoint.x + t5 * cos(theta)
        relPoint.y = relPoint.y + t5 * sin(theta)

        return reverseRelativePoint(relPoint)
    }

    /// Determine whether the specified point is in the rectangle
    ///
    /// Tests whether the point is between the left and right edges, and top and bottom edges
    /// - Parameter point: Whether the point is inside the rectangle
    public func contains(_ point: Vector) -> Bool {
        // Test X Coord
        let withinX = point.x < topLeft.x && point.x > topRight.x
        let withinY = point.y > bottomLeft.y && point.y < topLeft.y

        return withinX && withinY
    }
    
    open func draw(in context: CGContext) {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))
        context.stroke(rect)
        context.fill(rect)
    }
    
    open func debugDraw(in context: CGContext) {
        
        let tlColor = CGColor(red: 255 / 255, green: 159 / 255, blue: 82 / 255, alpha: 1)
        let trColor = CGColor(red: 82 / 255, green: 243 / 255, blue: 255 / 255, alpha: 1)
        let brColor = CGColor(red: 163 / 255, green: 82 / 255, blue: 255 / 255, alpha: 1)
        let blColor = CGColor(red: 255 / 255, green: 82 / 255, blue: 82 / 255, alpha: 1)
        
        context.setFillColor(tlColor)
        context.setStrokeColor(tlColor)
        Circle(center: topLeft, radius: 5).draw()
        topEdge.draw()
        
        context.setFillColor(trColor)
        context.setStrokeColor(trColor)
        Circle(center: topRight, radius: 5).draw()
        rightEdge.draw()
        
        context.setFillColor(brColor)
        context.setStrokeColor(brColor)
        Circle(center: bottomRight, radius: 5).draw()
        bottomEdge.draw()
        
        context.setFillColor(blColor)
        context.setStrokeColor(blColor)
        Circle(center: bottomLeft, radius: 5).draw()
        leftEdge.draw()
        
    }

    open func svgElement() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "rect"
        element.addAttribute(x, forKey: "x")
        element.addAttribute(y, forKey: "y")
        element.addAttribute(width, forKey: "width")
        element.addAttribute(height, forKey: "height")
        
        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }
}

extension Rectangle: Intersectable {
    
    /// Determine where the specified line intersects with the rectangle
    ///
    /// The rectangle tests whether the line intersects with each of its four edges
    /// - Parameter line: The line to test
    public func lineIntersection(_ line: Line) -> [Vector] {
        // Collect the edges
        let edges = [
            topEdge,
            bottomEdge,
            leftEdge,
            rightEdge
        ]
        
        return edges.reduce(into: [Vector]()) { (intersections, edge) in
            intersections.append(contentsOf: edge.lineIntersection(line))

        }

    }
    
}
