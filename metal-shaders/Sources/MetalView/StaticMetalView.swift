//
//  StaticMetalView.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 31/07/2025.
//

import MetalKit
import SwiftUI

struct StaticUniforms {
    var resolution: SIMD2<Float>
}

class StaticMetalView: MTKView {
    private(set) var commandQueue: MTLCommandQueue!
    private(set) var pipelineState: MTLRenderPipelineState!
    private(set) var vertexBuffer: MTLBuffer!
    private let contentItem: ContentItem

    let vertices: [SIMD2<Float>] = [
        [-1.0, -1.0], [1.0, -1.0], [-1.0, 1.0],
        [-1.0, 1.0], [1.0, -1.0], [1.0, 1.0]
    ]

    init(frame: CGRect, contentItem: ContentItem) {
        self.contentItem = contentItem
        super.init(frame: frame, device: MTLCreateSystemDefaultDevice())
        setupMetal()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("Coder init is not supported")
    }

    func setupMetal() {
        guard let device = self.device else { fatalError("Metal is not supported") }
        self.commandQueue = device.makeCommandQueue()

        guard let library = device.makeDefaultLibrary(),
              let fragmentFunction = library.makeFunction(name: contentItem.fragmentFunctionName),
              let vertexFunction = library.makeFunction(name: contentItem.vertexFunctionName)
        else { return }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat

        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }

        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<SIMD2<Float>>.stride * vertices.count, options: [])
    }

    override func draw(_ rect: CGRect) {
        guard let drawable = self.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = self.currentRenderPassDescriptor else { return }

        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        commandEncoder.setRenderPipelineState(pipelineState)

        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        var uniforms = StaticUniforms(resolution: SIMD2<Float>(Float(rect.width), Float(rect.height)))

        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<StaticUniforms>.size, index: 1)
        commandEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<StaticUniforms>.size, index: 0)

        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct StaticMetalViewRepresentable: NSViewRepresentable {
    private let contentItem: ContentItem

    init(contentItem: ContentItem) {
        self.contentItem = contentItem
    }

    func makeNSView(context: Context) -> StaticMetalView {
        let metalView = StaticMetalView(frame: .zero, contentItem: contentItem)
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = true
        metalView.isPaused = false
        return metalView
    }

    func updateNSView(_ nsView: StaticMetalView, context: Context) {}
}
