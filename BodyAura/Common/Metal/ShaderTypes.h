//
//  ShaderTypes.h
//  BodyAura
//
//  Created by Veronika Zelinkova on 09.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
typedef enum BufferIndices {
    kBufferIndexMeshPositions = 0
} BufferIndices;

// Attribute index values shared between shader and C code to ensure Metal shader vertex
//   attribute indices match the Metal API vertex descriptor attribute indices
typedef enum VertexAttributes {
    kVertexAttributePosition = 0,
    kVertexAttributeTexcoord = 1
} VertexAttributes;

// Texture index values shared between shader and C code to ensure Metal shader texture indices
//   match indices of Metal API texture set calls
typedef enum TextureIndices {
    kTextureIndexY = 0,
    kTextureIndexCbCr = 1,
    // TODO: 1 - Add kTextureMatte
    // TODO: 2 - Add kTextureBlurredMatte
    // TODO: 3 - Add kColor
} TextureIndices;

#endif /* ShaderTypes_h */
