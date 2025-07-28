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

// Rhodonea Fragment Shader — Draws layered rose curves with shadows

constant float b = 0.08;                      // Petal shape parameter
constant float n = 12;                        // Number of petals / frequency
constant float shadowWidth = 0.005;           // Width of the highlight ring (shadow edge)
constant float ratio = (1.0 + b) / (1.0 - b); // Ratio used to scale base radius between layers
constant int LAYERS = 7;                      // Total number of rose curve layers
constant float4 baseColor = float4(0.643, 0.624, 0.608, 1);

// Adjust the base radius for the next layer based on its index
void update_radius(thread float &radius, float i) {
    if (i > 4) {
        radius *= ratio - 0.01 / (1.0 - b);   // Slightly reduce growth rate for outer layers
    } else {
        radius *= ratio + 0.03 / (1.0 - b);   // Slightly increase growth rate for inner layers
    }
}

float4 first_petal_color(float distance, float4 color) {
    const float darkness = 0.6;
    const float blur = 0.2;
    const float4 shadowColor = float4(baseColor.rgb * darkness, baseColor.a);
    const float t = smoothstep(distance, distance - blur, 0.1);

    return mix(color, shadowColor, t);
}

float4 shadow_petal(float distance, float radius, int layer, float time) {
    const float ringWidth = 0.04 * (layer + 1);
    float inner = radius - ringWidth;
    float outer = radius;
    float t = smoothstep(inner, outer, distance);

    float4 shadowColor = float4(1, 1, 1, 1);

//    float4 color = float4(neonPalette(sin(radius + time)), 1);
    return mix(baseColor, shadowColor, t);
}

float rhodonea_radius(float r0, int i, int n, int sign, float theta) {
    float rotation = float(i) * (M_PI_F / n);     // Compute angular offset for layer
    float theta_i = theta + sign * rotation;      // Alternate rotation direction each layer

    return r0 * (1.0 + b * cos(n * theta_i));
}

// Fragment function: Draw rhodonea pattern based on texture coordinate
fragment float4 rhodonea(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    const float distance = length(in.texCoord); // Distance from center (polar coordinate r)
    const float theta = atan2(in.texCoord.y, in.texCoord.x) + M_PI_F / n; // Angle from x-axis + offset

    float r0 = 0.2; // Initial base radius for the first layer
    float prev_r = r0;
    float r = 0;
    // Loop through all rhodonea layers
    for (int i = 1, sign = 1; i <= LAYERS; ++i) {
        r = rhodonea_radius(r0, i, n, sign, theta);

        // If pixel is within the highlight ring (edge of petal), draw it white
        if (distance <= r && distance >= r - shadowWidth) {
            return float4(1, 1, 1, 1);
        }

        // If pixel is inside the petal (past the shadow edge), draw it with layer brightness
        if (i == 1 && distance <= r - shadowWidth) {
//            float4(neonPalette(sin(rhodonea_radius(r0, i, n, sign, theta + uniforms.time) + uniforms.time)), 1)
            return first_petal_color(distance, baseColor);
        } else if (i < LAYERS && distance <= r - shadowWidth) {
            float radius = r0 * (1 + b);
            return shadow_petal(distance, radius, i - 1, uniforms.time);
        } else if (distance <= r - shadowWidth) {
            float inner = prev_r;
            float outer = prev_r + 0.05;
            float tSample = smoothstep(inner, outer, distance);
            float4 colSample = mix(float4(0.91, 0.91, 0.91, 1), float4(1, 1, 1, 1), tSample);
            return colSample;
        }

        // Prepare for next layer: alternate rotation direction and update base radius
        sign *= -1;
        update_radius(r0, i);
        prev_r = r;
    }

    // Background color if no petal matched
    if (distance <= r + shadowWidth + 0.04) {
        float inner = prev_r;
        float outer = prev_r + 0.04;
        float tSample = smoothstep(inner, outer, distance);
        float4 colSample = mix(float4(0.91, 0.91, 0.91, 1), float4(0.95, 0.95, 0.95, 1), tSample);
        return colSample;
    }
    return float4(0.95, 0.95, 0.95, 1);
}

//            return float4(neonPalette(sin(r + uniforms.time)), 1);
//            return float4(neonPalette(r + uniforms.time), 1);
//            return float4(neonPalette(r), 1);
//            return float4(neonPalette(distance), 1);
