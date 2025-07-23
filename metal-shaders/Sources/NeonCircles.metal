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
    float distance = length(in.texCoord);
    float freq = 8.;
    float3 a = float3(0.8, 0.5, 0.4);
    float3 b = float3(0.2, 0.4, 0.2);
    float3 c = float3(2.0, 1.0, 1.0);
    float3 d = float3(0, 0.25, 0.25);
    float3 color = palette(distance + uniforms.time, a, b, c, d);

    distance = sin(distance * freq + uniforms.time) / freq;
    distance = abs(distance);
    distance = 0.02 / distance;
    color *= distance;

    return float4(color, 1);
}
