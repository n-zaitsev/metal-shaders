//
//  ContentItem.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

enum ContentItem: String, Identifiable, CaseIterable {
    var id: String {
        rawValue
    }
    
    case animatedGradient
    case blackWhiteCircles
    case neonCircles

    var fragmentFunctionName: String {
        switch self {
        case .animatedGradient:
            return "gradientFragmentShader"
        case .blackWhiteCircles:
            return "blackWhiteAnimatedCircles"
        case .neonCircles:
            return "neonCircles"
        }
    }

    var vertexFunctionName: String {
        switch self {
        case .animatedGradient:
            return "normalizedVertexShader"
        case .blackWhiteCircles, .neonCircles:
            return "defaultVertexShader"
        }
    }

    var title: String {
        switch self {
        case .animatedGradient:
            return "Animated Gradient"
        case .blackWhiteCircles:
            return "Black and White Animated Circles"
        case .neonCircles:
            return "Neon Circles"
        }
    }

    var animationSpeed: Float {
        switch self {
        case .neonCircles:
            return 1.0
        default:
            return 1.0
        }
    }
}
