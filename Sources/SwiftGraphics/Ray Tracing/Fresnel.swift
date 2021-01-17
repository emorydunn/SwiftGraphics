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
    
    /// Collimate rays hitting the back of the Fresnel
    /// - Parameter ray: The ray to modify
    public override func modifyRay(_ ray: Ray) {
        
        if normal().dot(ray.direction) < 0 {
            ray.terminateRay()
        } else {
            ray.direction = normal().normalized()
        }

    }

}
