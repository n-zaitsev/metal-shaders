//
//  DefaultShaders.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

#include <metal_stdlib>
#include "DefaultTypes.h"
using namespace metal;

vertex VertexOut normalizedVertexShader(uint vertexID [[vertex_id]], constant float2 *vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vertexID], 0.0, 1.0);
    out.texCoord = vertices[vertexID] * 0.5 + 0.5; // map from [-1; 1] to [0; 1]
    return out;
}

vertex VertexOut defaultVertexShader(uint vertexID [[vertex_id]], constant float2 *vertices [[buffer(0)]], constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut out;
    out.position = float4(vertices[vertexID], 0.0, 1.0);
    out.texCoord = vertices[vertexID] * uniforms.resolution / uniforms.resolution.y;
    return out;
}
