//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/6/22.
//

import Foundation

public protocol Shape {
    
    func pointOnPerimeter(_ t: Double) -> Vector
    
    func sampled(every interval: Double) -> Path
    func sampled(every interval: Double) -> [Vector]
    func randomSample(every interval: Double, threshold: Double) -> [Path]
    func randomSample(every interval: Double, threshold: (Double, Double) -> Bool) -> [Path] 
}

extension Shape {
    public func asShapes() -> [Shape] { [self] }
}

extension Shape {
    /// Create a `Path` by sampling the curve.
    /// - Parameter interval: The interval at which to sample the path.
    /// - Returns: A `Path` following the curve.
    public func sampled(every interval: Double = 0.01) -> Path {
        Path(strideFrom: 0, through: 1, by: interval) {
            pointOnPerimeter($0)
        }
    }
    
    /// Create a `Path` by sampling the curve.
    /// - Parameter interval: The interval at which to sample the path.
    /// - Returns: A `Path` following the curve.
    public func sampled(every interval: Double = 0.01) -> [Vector] {
        stride(from: 0, through: 1, by: interval).map {
            pointOnPerimeter($0)
        }
    }
    
    /// Randomly sample the curve.
    /// - Parameters:
    ///   - interval: The interval at which to sample the path.
    ///   - threshold: The threshold over which the noise must be for the segments inclusion.
    /// - Returns: An Array of Line segments along the curve.
    public func randomSample(every interval: Double = 0.01, threshold: Double = 0.5) -> [Path] {
        
        randomSample(every: interval) { _, noise in
            noise < threshold
        }

    }
        
    /// Randomly sample the curve.
    /// - Parameters:
    ///   - interval: The interval at which to sample the path.
    ///   - threshold: The threshold over which the noise must be for the segments inclusion.
    /// - Returns: An Array of Line segments along the curve.
    public func randomSample(every interval: Double = 0.01, threshold: (Double, Double) -> Bool) -> [Path] {
        let generator = PerlinGenerator()
        
        var paths: [Path] = []
        var workingPath = Path()
        
        let points = stride(from: 0, through: 1, by: interval)
        let count = 1 / interval
        
        points.enumerated().forEach { index, step in
            let point = pointOnPerimeter(step)
            let noise = generator.noise(point)
            let percent = Double(index) / Double(count)
            
            // If the point passes add it to the working path
            // If not, end the path
            if threshold(percent, noise) {
                workingPath.addPoint(point)
            } else {
                // If the working path is empty it means we've had multiple
                // points excluded in a row, so we don't have to do anything
                if !workingPath.isEmpty {
                    paths.append(workingPath)
                    workingPath = Path()
                }
            }
        }
        
        paths.append(workingPath)
        return paths

    }
}
