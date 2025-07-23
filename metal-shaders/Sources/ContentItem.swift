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
    

    var fragmentFunctionName: String {
        switch self {
        case .animatedGradient:
            return "gradientFragmentShader"
        case .blackWhiteCircles:
            return "blackWhiteAnimatedCircles"
        }
    }

    var vertexFunctionName: String {
        switch self {
        case .animatedGradient:
            return "normalizedVertexShader"
        case .blackWhiteCircles:
            return "defaultVertexShader"
        }
    }

    var title: String {
        switch self {
        case .animatedGradient:
            return "Animated Gradient"
        case .blackWhiteCircles:
            return "Black and White Animated Circles"
        }
    }
}
