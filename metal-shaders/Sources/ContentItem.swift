//
//  ContentItem.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

enum ContentItem: String, Identifiable {
    var id: String {
        rawValue
    }
    
    case animatedGradient

    var fragmentFunctionName: String {
        switch self {
        case .animatedGradient:
            return "gradientFragmentShader"
        }
    }

    var vertexFunctionName: String {
        switch self {
        case .animatedGradient:
            return "gradientVertexShader"
        }
    }

    var title: String {
        switch self {
        case .animatedGradient:
            return "Animated Gradient"
        }
    }
}
