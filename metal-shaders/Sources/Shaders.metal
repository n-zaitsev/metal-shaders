//
//  Shaders.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 30/05/2025.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                              constant float2 *vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(vertices[vertexID], 0.0, 1.0);
    out.texCoord = vertices[vertexID] * 0.5 + 0.5;
    return out;
}

struct Uniforms {
    float2 resolution;
    float time;
};

float4 waves(float2 fragCoord, float2 resolution, float time) {
    float h = 11.0 - (fragCoord.y / resolution.y) / 0.1;
    float c = round(h);
    float y = sin((fragCoord.x / resolution.y) / 0.06 + time * c + c * c) * 0.4;
    float o = 1.0 - resolution.y / 30.0 * abs(y - h + c);

    return float4(o, o, o, 1.0);
}

fragment float4 fragmentShader(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    return waves(in.texCoord * uniforms.resolution, uniforms.resolution, uniforms.time);
}
