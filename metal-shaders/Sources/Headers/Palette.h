//
//  Palette.h
//  metal-shaders
//
//  Created by Nikita Zaitsev on 24/07/2025.
//

#ifndef Palette_h
#define Palette_h

#include <metal_stdlib>
using namespace metal;

inline float3 palette(float t, float3 a, float3 b, float3 c, float3 d) {
    return a + b*cos(6.283185*(c*t+d));
}

inline float3 neonPalette(float t) {
    float3 a = float3(0.5, 0.5, 0.5);
    float3 b = float3(0.5, 0.5, 0.5);
    float3 c = float3(2.0, 1.0, 0.0);
    float3 d = float3(0.50, 0.20, 0.25);

    return palette(t, a, b, c, d);
}

#endif /* Palette_h */
