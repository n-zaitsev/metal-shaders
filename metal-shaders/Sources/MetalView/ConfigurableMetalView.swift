//
//  ConfigurableMetalView.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 31/07/2025.
//

import SwiftUI

struct ConfigurableUniforms {
    var resolution: SIMD2<Float>
}

final class ConfigurableAnimatableMetalView: StaticMetalView {

    override init(frame: CGRect, contentItem: ContentItem) {
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

        var uniforms = ConfigurableUniforms(resolution: SIMD2<Float>(Float(rect.width), Float(rect.height)))

        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<ConfigurableUniforms>.stride, index: 1)
        commandEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<ConfigurableUniforms>.stride, index: 0)

        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct ConfigurableMetalViewRepresentable: NSViewRepresentable {
    private let contentItem: ContentItem

    init(contentItem: ContentItem) {
        self.contentItem = contentItem
    }

    func makeNSView(context: Context) -> ConfigurableAnimatableMetalView {
        let metalView = ConfigurableAnimatableMetalView(frame: .zero, contentItem: contentItem)
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = true
        metalView.isPaused = false
        return metalView
    }

    func updateNSView(_ nsView: ConfigurableAnimatableMetalView, context: Context) {}
}
