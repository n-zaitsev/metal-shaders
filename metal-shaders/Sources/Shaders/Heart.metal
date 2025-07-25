//
//  Heart.metal
//  metal-shaders
//
//  Created by Nikita Zaitsev on 25/07/2025.
//

#include <metal_stdlib>
#include "DefaultTypes.h"
using namespace metal;

fragment float4 heart(VertexOut in [[stage_in]], constant Uniforms &u [[buffer(0)]]) {
    return float4(1, 1, 1, 1);
}
