//
//  DefaultTypes.h
//  metal-shaders
//
//  Created by Nikita Zaitsev on 23/07/2025.
//

#ifndef DefaultTypes_h
#define DefaultTypes_h

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

struct Uniforms {
    float2 resolution;
    float time;
};

#endif /* DefaultTypes_h */
