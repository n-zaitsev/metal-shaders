//
//  MetalView.swift
//  metal-shaders
//
//  Created by Nikita Zaitsev on 30/05/2025.
//

import MetalKit
import SwiftUI

struct Uniforms {
    var resolution: SIMD2<Float>
    var time: Float
    var padding: Float = 0
}

final class MetalView: MTKView {
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var time: Float = 0.0
    var vertexBuffer: MTLBuffer!
    var animationSpeed: Float = 1

    let vertices: [SIMD2<Float>] = [
        [-1.0, -1.0], [1.0, -1.0], [-1.0, 1.0],
        [-1.0, 1.0], [1.0, -1.0], [1.0, 1.0]
    ]

    init(frame: CGRect, animationSpeed: Float = 1.0) {
        super.init(frame: frame, device: MTLCreateSystemDefaultDevice())
        self.animationSpeed = animationSpeed
        setupMetal()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupMetal()
    }

    func setupMetal() {
        guard let device = self.device else { fatalError("Metal is not supported") }
        self.commandQueue = device.makeCommandQueue()

        guard let library = device.makeDefaultLibrary(),
              let fragmentFunction = library.makeFunction(name: "fragmentShader"),
              let vertexFunction = library.makeFunction(name: "vertexShader")
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

        var uniforms = Uniforms(
            resolution: SIMD2<Float>(Float(rect.width), Float(rect.height)),
            time: time
        )

        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 1)
        commandEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 0)

        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)

        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()

        time += 0.01 * animationSpeed
    }
}

struct MetalViewRepresentable: NSViewRepresentable {
    func makeNSView(context: Context) -> MetalView {
        let metalView = MetalView(frame: .zero, animationSpeed: 0.5)
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = true
        metalView.isPaused = false
        return metalView
    }

    func updateNSView(_ nsView: MetalView, context: Context) {
        // Здесь можно обновить параметры MetalView при изменении состояния
        nsView.animationSpeed = 0.5
    }
}
