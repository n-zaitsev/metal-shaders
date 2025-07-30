//
//  NeonCircles.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

#include <metal_stdlib>
#include "../Headers/DefaultTypes.h"
#include "../Headers/Palette.h"
using namespace metal;

fragment float4 neonCircles(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    float2 uv = in.texCoord;
    float freq = 8.;
    float3 finalColor = float3(0);

    for (int i = 0; i < 3; ++i) {
        uv = fract(1.5 * uv) - 0.5;
        float distance = length(uv);
        float3 color = neonPalette(length(in.texCoord) + uniforms.time);
        
        distance = sin(distance * freq + uniforms.time) / freq;
        distance = abs(distance);
        distance = pow(0.02 / distance, 2);
        finalColor += color * distance;
    }

    return float4(finalColor, 1);
}
