//
//  Fresnel.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A specialized `RayTracer` that collimates intersecting rays and casts them along the vector normal of the lens
public class Fresnel: Line {

    /// The angle at which rays are reflected, relative to the normal
    public var reflectionAngle: Degrees = 180

    public override func modifyRay(_ ray: Ray) {
        
        ray.direction.rotate(to: reflectionAngle.toRadians() + normal().heading())
        
    }

}
