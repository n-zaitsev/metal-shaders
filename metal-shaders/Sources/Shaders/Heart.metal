//
//  Heart.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 25/07/2025.
//

#include <metal_stdlib>
#include "../Headers/DefaultTypes.h"
using namespace metal;

constant float radius = 1.0;
constant float2 shadowOffset = float2(0.1, -0.1); // Смещение тени (x, y)
constant float shadowBlur = 0.3; // Размытие тени
constant float4 shadowColor = float4(0.0, 0.0, 0.0, 0.5); // Цвет тени с прозрачностью

fragment float4 heart(VertexOut in [[stage_in]], constant Uniforms& u [[buffer(0)]]) {
    float2 coord = in.texCoord;
    
    // Расстояние до центра основной фигуры
    float d = length(coord);
    
    // Расстояние до центра тени (смещенной позиции)
    float2 shadowCoord = coord - shadowOffset;
    float shadowDist = length(shadowCoord);
    
    // Создаем основную фигуру
    bool isInMain = d <= radius;
    
    // Создаем тень с размытием
    float shadowFactor = 1.0 - smoothstep(radius, radius + shadowBlur, shadowDist);
    shadowFactor = max(0.0, shadowFactor);
    
    // Если мы внутри основной фигуры
    if (isInMain) {
        return float4(0.3, 0.3, 0.3, 1.0); // Основной цвет
    }
    
    // Если мы в области тени, но не в основной фигуре
    if (shadowFactor > 0.0) {
        // Смешиваем тень с фоном
        float4 background = float4(1.0, 1.0, 1.0, 1.0);
        return mix(background, shadowColor, shadowFactor * shadowColor.a);
    }
    
    // Фон
    return float4(1.0, 1.0, 1.0, 1.0);
}
