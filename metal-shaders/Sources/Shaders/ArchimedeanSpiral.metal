//
//  ArchimedeanSpiral.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 24/07/2025.
//

#include <metal_stdlib>
#include "DefaultTypes.h"
#include "Palette.h"
using namespace metal;

fragment float4 archimedeanSpiral(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]], constant float &n [[buffer(2)]]) {
    float b = 0.008;
    float distance = length(in.texCoord);
    float theta = atan2(in.texCoord.y, in.texCoord.x);

    float thickness = 0.005;

    for (int i = 0; i < int(40); ++i) {
        float rotatedTheta = fmod(theta + uniforms.time, 2.0 * M_PI_F);
        float r = b * (rotatedTheta + i * 2.0 * M_PI_F);
        float d = abs(distance - r);

        if (d <= thickness) {
            float3 color = neonPalette(sin(distance + uniforms.time));
            return float4(color, 1);
        }
    }
    
    return float4(0, 0, 0, 1.0);
}
