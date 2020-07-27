//
//  BlendMode.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/2/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import AppKit

/// Compositing operations for images.
public enum BlendMode: String {
    /// Paints the source image samples over the background image samples.
    case normal
    
    /// Multiplies the source image samples with the background image samples.
    /// This results in colors that are at least as dark as either of the two contributing sample colors.
    case multiply
    
    /// Multiplies the inverse of the source image samples with the inverse of the background image samples, resulting in
    /// colors that are at least as light as either of the two contributing sample colors.
    case screen
    
    /// Either multiplies or screens the source image samples with the background image samples, depending on the background color.
    /// The result is to overlay the existing image samples while preserving the highlights and shadows of the background.
    /// The background color mixes with the source image to reflect the lightness or darkness of the background.
    case overlay
    
    /// Creates the composite image samples by choosing the darker samples (either from the source image or the background).
    /// The result is that the background image samples are replaced by any source image samples that are darker.
    /// Otherwise, the background image samples are left unchanged.
    case darken
    
    /// Creates the composite image samples by choosing the lighter samples (either from the source image or the background).
    /// The result is that the background image samples are replaced by any source image samples that are lighter.
    /// Otherwise, the background image samples are left unchanged.
    case lighten
    
    /// Brightens the background image samples to reflect the source image samples. Source image sample values that specify black do not produce a change.
    case colorDodge = "color-dodge"
    
    /// Darkens the background image samples to reflect the source image samples. Source image sample values that specify white do not produce a change.
    case colorBurn = "color-burn"
    
    /// Either multiplies or screens colors, depending on the source image sample color.
    /// If the source image sample color is lighter than 50% gray, the background is lightened, similar to screening.
    /// If the source image sample color is darker than 50% gray, the background is darkened, similar to multiplying.
    /// If the source image sample color is equal to 50% gray, the source image is not changed.
    /// Image samples that are equal to pure black or pure white result in pure black or white.
    /// The overall effect is similar to what you’d achieve by shining a harsh spotlight on the source image. Use this to add highlights to a scene.
    case hardLight = "hard-light"
    
    /// Either darkens or lightens colors, depending on the source image sample color.
    /// If the source image sample color is lighter than 50% gray, the background is lightened, similar to dodging.
    /// If the source image sample color is darker than 50% gray, the background is darkened, similar to burning.
    /// If the source image sample color is equal to 50% gray, the background is not changed.
    /// Image samples that are equal to pure black or pure white produce darker or lighter areas, but do not result in pure black or white.
    /// The overall effect is similar to what you’d achieve by shining a diffuse spotlight on the source image. Use this to add highlights to a scene.
    case softLight = "soft-light"
    
    /// Subtracts either the source image sample color from the background image sample color, or the reverse,
    /// depending on which sample has the greater brightness value. Source image sample values that are black
    /// produce no change; white inverts the background color values.
    case difference
    
    /// Produces an effect similar to that produced by BlendMode.difference, but with lower contrast.
    /// Source image sample values that are black don’t produce a change; white inverts the background color values.
    case exclusion
    
    /// Uses the luminance and saturation values of the background with the hue of the source image.
    case hue
    
    /// Uses the luminance and hue values of the background with the saturation of the source image.
    /// Areas of the background that have no saturation (that is, pure gray areas) don’t produce a change.
    case saturation
    
    /// Uses the luminance values of the background with the hue and saturation values of the source image.
    /// This mode preserves the gray levels in the image. You can use this mode to color monochrome images or to tint color images.
    case color
    
    /// Uses the hue and saturation of the background with the luminance of the source image.
    /// This mode creates an effect that is inverse to the effect created by BlendMode.color.
    case luminosity
    
    /// Returns the corresponding `CGBlendMode`
    public var cgBlendMode: CGBlendMode {
        switch self {
        case .normal: return .normal
        case .multiply: return .multiply
        case .screen: return .screen
        case .overlay: return .overlay
        case .darken: return .darken
        case .lighten: return .lighten
        case .colorDodge: return .colorDodge
        case .colorBurn: return .colorBurn
        case .hardLight: return .hardLight
        case .softLight: return .softLight
        case .difference: return .difference
        case .exclusion: return .exclusion
        case .hue: return .hue
        case .saturation: return .saturation
        case .color: return .color
        case .luminosity: return .luminosity
        }
    }
    
    /// Set the blend mode of the current `CGContext`
    public func setCGBlenMode() {
        NSGraphicsContext.current?.cgContext.setBlendMode(cgBlendMode)
    }
}
