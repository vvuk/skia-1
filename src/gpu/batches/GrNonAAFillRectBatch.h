/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrNonAAFillRectBatch_DEFINED
#define GrNonAAFillRectBatch_DEFINED

#include "GrColor.h"

class GrDrawOp;
class SkMatrix;
struct SkRect;

namespace GrNonAAFillRectBatch {

GrDrawOp* Create(GrColor color,
                 const SkMatrix& viewMatrix,
                 const SkRect& rect,
                 const SkRect* localRect,
                 const SkMatrix* localMatrix);

GrDrawOp* CreateWithPerspective(GrColor color,
                                const SkMatrix& viewMatrix,
                                const SkRect& rect,
                                const SkRect* localRect,
                                const SkMatrix* localMatrix);

};

#endif
