//
//  Circle+RayTracable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 1/18/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

extension Circle: RayTracable {
    
    /// Return the intersection of a ray
    ///
    /// Based on this [algorithm ][] by Деян Добромиров, and an explanation of [t values][tValue] by Victor Li.
    ///
    /// [algorithm]: https://math.stackexchange.com/a/2633290
    /// [tValue]: http://viclw17.github.io/2018/07/16/raytracing-ray-sphere-intersection/
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    public func rayIntersection(_ ray: Ray) -> Vector? {
        
        let originDiffs = ray.origin - center
        
        let a = ray.direction.magSq()
        let b = 2 * ray.direction.dot(originDiffs)
        let c = originDiffs.magSq() - radius.squared()
        
        let discr = b.squared() - 4 * a * c
        
        guard discr > 0 else { return nil }
        
        let g = 1 / (2 * a)
        let determ = g * sqrt(discr)
        let newB = -b * g
        
        let t0 = newB + determ
        let t1 = newB - determ
        
        guard let tValue = [t0, t1].filter({ $0 > 0 && $0.rounded() != 0}).sorted().first else {
            return nil
        }
        
        return ray.origin + ray.direction * tValue
    }
    
    
//    public func modifyRay(_ ray: Ray) {
//        deflectRay(ray)
//    }
}
