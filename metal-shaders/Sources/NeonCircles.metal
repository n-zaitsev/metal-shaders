//
//  NeonCircles.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

#include <metal_stdlib>
#include "DefaultTypes.h"
using namespace metal;


float3 palette(float t, float3 a, float3 b, float3 c, float3 d ) {
    return a + b*cos(6.283185*(c*t+d));
}

fragment float4 neonCircles(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    float2 uv = in.texCoord;
    float freq = 8.;
    float3 a = float3(0.5, 0.5, 0.5);
    float3 b = float3(0.5, 0.5, 0.5);
    float3 c = float3(2.0, 1.0, 0.0);
    float3 d = float3(0.50, 0.20, 0.25);
    float3 finalColor = float3(0);

    for (int i = 0; i < 3; ++i) {
        uv = fract(1.5 * uv) - 0.5;
        float distance = length(uv);
        float3 color = palette(length(in.texCoord) + uniforms.time, a, b, c, d);
        
        distance = sin(distance * freq + uniforms.time) / freq;
        distance = abs(distance);
        distance = pow(0.02 / distance, 2);
        finalColor += color * distance;
    }

    return float4(finalColor, 1);
}
