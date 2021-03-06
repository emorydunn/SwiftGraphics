# Changelog

All notable changes to this project will be documented in this file. The project follows semantic versioning.

## 0.3.2 / Unreleased

- [CHANGED] Mark XMLElement extension methods public
- [ADDED] Create a `Line` segment from an origin, direction, and length
- [ADDED] Vector rotation around another point
- [CHANGED] Move `center` to `Shape`
- [ADDED] Random `Vector` init
- [CHANGED] Move drawing methods to `Sketch`
- [ADDED] Array methods for `Polygon.contains(_:)`
- [ADDED] Create a grid of `Vector`s in a `Polygon`
- [ADDED] Barrel distortion for `Vector`
- [ADDED] Create `Size` from inches and mm
- [CHANGED] Add SVG attribute enum for grouping elements into layers
- [ADDED] HatchFill for Polygons

## 0.3.1 / 2021-02-21

- [CHANGED] Document changes from 0.3.0
- [CHANGED] Smoothing has been removed from `Path`, use `BezierPath` instead
- [CHANGED] Move Bézier control point calculation to `Vector`

## 0.3.0 / 2021-02-19

- [CHANGED] Shapes are now hashable
- [FIXED] Vector init ambiguity
- [CHANGED] Use proper XMLElement init
- [ADDED] `BezierPath`
- [ADDED] Pi constants
- [ADDED] `Size` to `NSSize`
- [ADDED] Boolean operations
- [ADDED] Ray tracing
- [ADDED] Shape intersections
- [ADDED] Perlin noise value for a vector


## 0.2.0 / 2020-07-25

- [ADDED] Save SVGs directly to a URL
- [ADDED] Default alpha in `Color`
- [ADDED] Piles of documentation


## 0.1.0 / 2020-07-25

- [ADDED] Shape primitives
- [ADDED] SVG drawing
- [ADDED] CoreGraphics drawing
- [ADDED] Perlin Noise generator
