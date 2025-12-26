//
//  Ray.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-24.
//


/// An object representing a set of straight lines originating from a point.
/// 
/// The `Ray` may be modified by intersecting it with other `Shape`s
public class Ray {
    
    /// The position of the ray
    public var origin: Vector
    
    /// The direction of the ray
    public var direction: Vector

    /// The path the ray has taken
	public var path: Path

    /// Whether or no the ray is terminated
    ///
    /// If this value is true no more tracing will be done
    public var isTerminated: Bool = false
    
    /// How many steps the ray has taken
    ///
    /// The ray is limited to 1000 iterations
    var iterationCount = 0 {
        didSet {
            if iterationCount > 1000 {
                print("Iteration count has crossed threshold")
                terminateRay()
            }
        }
    }
    
    /// Instantiate a new Ray.
    /// - Parameters:
    ///   - origin: The position of the Ray
    ///   - direction: The direction of the Ray
    public init(origin: Vector, direction: Vector) {
        self.origin = origin
        self.direction = direction
		self.path = Path()
    }
    
    /// Instantiate a new Ray.
    /// - Parameters:
    ///   - x: The X position of the Ray.
    ///   - y: The Y position of the Ray.
    ///   - direction: The direction of the Ray, in degrees.
    public convenience init(x: Double, y: Double, direction: Angle) {
        self.init(
            origin: Vector(x, y),
            direction: Vector(angle: direction))
    }
    
    /// Remove the ray's saved path and reset its iterations
    public func resetPath() {
        path.removeAll()
        iterationCount = 0
    }
    
    /// Stop the receiver from continuing to trace new paths.
    public func terminateRay() {
        isTerminated = true
    }
    
    /// Perform the ray tracing operation.
    /// - Parameter objects: The objects to trace against.
    public func run(objects: [RayTracable]) {
		self.path = Path(origin)

        while isTerminated == false {
            var closestDistance = Double.infinity
            var closestObject: RayTracable?
            var closestPoint: Vector?
            
            // Find the closest intersecting object
            for object in objects {
                // Find any intersecting points
                guard let intersection = object.rayIntersection(self) else { continue }

                // Calculate the distance to the intersection
				let dist = intersection.distance(to: origin)

                // If this point is closer than the previous one, replace it
                if dist < closestDistance {
                    closestPoint = intersection
                    closestDistance = dist
                    closestObject = object
                }
            }
            
            // If we have an intersection add its line to the ray
            // and ask the object to modify the ray.
            // Otherwise, terminate the ray
            if let closestObject, let closestPoint {

				if closestPoint == origin {
					terminateRay()
					return
				}

				path.addPoint(closestPoint)
                origin = closestPoint
                closestObject.modifyRay(self)
                
            } else {
                terminateRay()
            }

			iterationCount += 1

        }
    }
    
    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(in context: DrawingContext) {
        path.draw(in: context)
    }


}

extension Array where Element: Ray {
    /// A convenience method to draw an array of Rays
    public func draw(in context: DrawingContext) {
        self.forEach { $0.draw(in: context) }
    }
}
