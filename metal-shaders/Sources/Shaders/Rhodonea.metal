//
//  Rhodonea.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 25/07/2025.
//

#include <metal_stdlib>
#include "DefaultTypes.h"
#include "Palette.h"
using namespace metal;

constant float b = 0.08;
constant float n = 12;
constant float shadowWidth = 0.005;
constant float ratio = (1.0 + b) / (1.0 - b);
constant int LAYERS = 7;

void update_radius(thread float &radius, float i) {
    if (i > 4) {
        radius *= ratio - 0.01 / (1.0 - b);
    } else {
        radius *= ratio + 0.03 / (1.0 - b);
    }
}

fragment float4 rhodonea(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    const float distance = length(in.texCoord);
    const float theta = atan2(in.texCoord.y, in.texCoord.x) + M_PI_F / n;
    
    float r0 = 0.2;

    for (int i = 1, sign = 1; i <= LAYERS; ++i) {
        float rotation = float(i) * (M_PI_F / n);

        float theta_i = theta + sign * rotation;

        float r = r0 * (1.0 + b * cos(n * theta_i));

        if (distance <= r && distance >= r - shadowWidth) {
            return float4(1, 1, 1, 1);
        }

        float layerDarkness = float(i) / float(LAYERS);
        float baseBrightness = mix(0.6, 1.0, 0.0 + layerDarkness);

        if (distance <= r - shadowWidth) {
            return float4(baseBrightness, baseBrightness, baseBrightness, 1);
        }

        sign *= -1;
        update_radius(r0, i);
    }

    return float4(0.95, 0.95, 0.95, 1);
}

//            return float4(neonPalette(sin(r + uniforms.time)), 1);
//            return float4(neonPalette(r + uniforms.time), 1);
//            return float4(neonPalette(r), 1);
//            return float4(neonPalette(distance), 1);
