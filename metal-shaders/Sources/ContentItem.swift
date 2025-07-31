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
    case archimedeanSpiral
    case heart
    case rhodonea

    var fragmentFunctionName: String {
        switch self {
        case .animatedGradient:
            return "gradientFragmentShader"
        case .blackWhiteCircles:
            return "blackWhiteAnimatedCircles"
        case .neonCircles:
            return "neonCircles"
        case .archimedeanSpiral:
            return "archimedeanSpiral"
        case .heart:
            return "heart"
        case .rhodonea:
            return "rhodonea"
        }
    }

    var vertexFunctionName: String {
        switch self {
        case .animatedGradient:
            return "normalizedVertexShader"
        case .heart, .rhodonea:
            return "defaultStaticVertexShader"
        case .blackWhiteCircles, .neonCircles, .archimedeanSpiral:
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
        case .archimedeanSpiral:
            return "Archimedean Spiral"
        case .heart:
            return "Heart"
        case .rhodonea:
            return "Rhodonea"
        }
    }
}
