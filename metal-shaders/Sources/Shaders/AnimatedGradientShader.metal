//
//  Shaders.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 30/05/2025.
//

#include <metal_stdlib>
#include "../Headers/DefaultTypes.h"
using namespace metal;

float4 gradient(float2 fragCoord, float2 resolution, float time) {
    float loopedTime = sin(time);
    float colorX = fragCoord.x / resolution.x;
    float colorY = fragCoord.y / resolution.y;

    float progress = abs(loopedTime);
    float directionX = (loopedTime > 0.0) ? colorX : (1.0 - colorY);
    float directionY = (loopedTime > 0.0) ? colorY : (1.0 - colorX);

    float animatedColorX = directionX * progress;
    float animatedColorY = directionY * progress;

    float brightness = (animatedColorX + animatedColorY) * 0.5;
    return float4(animatedColorX, animatedColorY, brightness, 1.0);
}


fragment float4 gradientFragmentShader(VertexOut in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    return gradient(in.texCoord * uniforms.resolution, uniforms.resolution, uniforms.time);
}
