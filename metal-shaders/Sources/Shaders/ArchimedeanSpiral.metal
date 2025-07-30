//
//  ArchimedeanSpiral.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 24/07/2025.
//

#include <metal_stdlib>
#include "../Headers/DefaultTypes.h"
#include "../Headers/Palette.h"
using namespace metal;

fragment float4 archimedeanSpiral(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    float2 uv = in.texCoord;
    float b = 0.008;
    float thickness = 0.01;
    float3 finalColor = float3(0);

    for (int j = 0; j < 2; ++j) {
        uv = fract(uv) - 0.5;

        float distance = length(uv);
        float theta = atan2(uv.y, uv.x);
        float3 color = neonPalette(sin(distance + uniforms.time) / 2);

        for (int i = 0; i < 20; ++i) {
            float rotatedTheta = fmod(theta + uniforms.time, 2.0 * M_PI_F);
            float r = b * (rotatedTheta + i * 2.0 * M_PI_F);
            float d = abs(distance - r);
            
            if (d <= thickness) {
                float depthFade = smoothstep(thickness, 0.0, d);
                float radialFade = smoothstep(0.8, 0.0, distance);
                finalColor += color * depthFade * radialFade;
            }
        }
    }
    
    return float4(finalColor, 1.0);
}
