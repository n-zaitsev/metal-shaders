//
//  MetalViewFactory.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 31/07/2025.
//

import SwiftUI

private enum Constants {
    static let animationSpeed: Float = 1
}
struct MetalViewFactory {
    @ViewBuilder
    static func makeView(for item: ContentItem) -> some View {
        switch item {
        case .animatedGradient, .blackWhiteCircles, .neonCircles, .archimedeanSpiral:
            InfiniteAnimatableMetalViewRepresentable(animationSpeed: Constants.animationSpeed, contentItem: item)
        case .heart:
            StaticMetalViewRepresentable(contentItem: item)
        case .rhodonea:
            ConfigurableMetalViewRepresentable(contentItem: item)
        }
    }
}
