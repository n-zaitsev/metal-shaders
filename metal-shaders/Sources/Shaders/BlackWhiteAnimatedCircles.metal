//
//  BlackWhiteAnimatedCircles.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

#include <metal_stdlib>
#include "../Headers/DefaultTypes.h"
using namespace metal;

fragment float4 blackWhiteAnimatedCircles(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    float distance = length(in.texCoord);
    float freq = 8.0;
    distance = sin(distance * freq + uniforms.time);
    distance = abs(distance);
    distance = smoothstep(0, 0.1, distance);

    return float4(distance, distance, distance, 1.0);
}
