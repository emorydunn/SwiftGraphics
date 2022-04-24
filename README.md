# SwiftGraphics

![Swift](https://github.com/emorydunn/SwiftGraphics/workflows/Swift/badge.svg) ![Documentation badge](https://emorydunn.github.io/SwiftGraphics/badge.svg)

SwiftGraphics is a library for creative coding and generative art tailored towards rending SVGs meant for pen plotting.

Take a look at the [documentation](https://emorydunn.github.io/SwiftGraphics/) and visit the [example repo](https://github.com/emorydunn/SwiftGraphics-Example) for a working reference.

![Ray Tracing Example](https://raw.githubusercontent.com/emorydunn/SwiftGraphics/main/Examples/20210118-153510-5b61a3fb.png)

# SwiftGraphics2

This branch is a rewrite of the basic shapes using `simd` to provide hopefully faster processing and other features like rotation, proper Bézier curves, and cleaner code.

It's still a work in progress and will most likely not be fully compatible with the existing library. 

# 2D Primitives

- Circle
- Rectangle
  - BoundingBox
- Line
- Path
- Bézier path

# Ray Tracing

- Directional emitter
- Radial emitter
- Linear emitter
- Fresnel lenses
- Refraction

# Vectors

- 2D Vectors

# Rendering

- SVG output
- PNG output
