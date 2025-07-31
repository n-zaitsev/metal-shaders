//
//  InfiniteAnimatableMetalView.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 30/05/2025.
//

import MetalKit
import SwiftUI

struct Uniforms {
    var resolution: SIMD2<Float>
    var time: Float
}

final class InfiniteAnimatableMetalView: StaticMetalView {
    private var time: Float = 0.0
    var animationSpeed: Float


    init(frame: CGRect, animationSpeed: Float = 1.0, contentItem: ContentItem) {
        self.animationSpeed = animationSpeed
        super.init(frame: frame, contentItem: contentItem)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("Coder init is not supported")
    }

    override func draw(_ rect: CGRect) {
        guard let drawable = self.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = self.currentRenderPassDescriptor else { return }

        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        commandEncoder.setRenderPipelineState(pipelineState)

        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        var uniforms = Uniforms(
            resolution: SIMD2<Float>(Float(rect.width), Float(rect.height)),
            time: time
        )

        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)

        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()

        time += 0.01 * animationSpeed
    }
}

struct InfiniteAnimatableMetalViewRepresentable: NSViewRepresentable {
    private let animationSpeed: Float
    private let contentItem: ContentItem

    init(animationSpeed: Float, contentItem: ContentItem) {
        self.animationSpeed = animationSpeed
        self.contentItem = contentItem
    }

    func makeNSView(context: Context) -> InfiniteAnimatableMetalView {
        let metalView = InfiniteAnimatableMetalView(frame: .zero, animationSpeed: animationSpeed, contentItem: contentItem)
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = true
        metalView.isPaused = false
        return metalView
    }

    func updateNSView(_ nsView: InfiniteAnimatableMetalView, context: Context) {
        nsView.animationSpeed = animationSpeed
    }
}
