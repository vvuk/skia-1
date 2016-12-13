/// <div rustbindgen replaces="std::unique_ptr"></div>
template<typename T, typename D>
class unique_ptr_replacement {
  T* ptr;
};

/// <div rustbindgen replaces="SkOnce"></div>
class once_replacement { unsigned char v; };

#if defined(_MSC_VER) && defined(_M_AMD64)
/*
 * With the MSVC x64 ABI, structs are returned in RAX if and only if
 * they are <= 8 bytes in size, *and are effectively a POD type*.  See
 * https://msdn.microsoft.com/en-us/library/7572ztz4.aspx .
 * Unfortunately, I can't figure out how to tell Rust this.  In C++,
 * sk_sp<T> has a user-defined constructor, destructor, etc.  In Rust,
 * no such information exists.
 *
 * So, we add a dummy field to this struct, making it 16 bytes.  This
 * changes this from the C++ struct, *but* this is only ever used as
 * a return type.  So this should be safe.  Fingers are crossed.
 */
/// <div rustbindgen replaces="sk_sp"></div>
template<typename T>
class sk_sp_replacement { T* ptr; void* dummy; };
#endif

#if 1
#include "core/SkImage.h"
#include "core/SkCanvas.h"
#include "core/SkSurface.h"


#include "core/SkAnnotation.h"
#include "core/SkBBHFactory.h"
#include "core/SkBitmap.h"
#include "core/SkBitmapDevice.h"
#include "core/SkBlitRow.h"
#include "core/SkBlurTypes.h"
#include "private/SkChunkAlloc.h"
#include "core/SkClipStack.h"
#include "core/SkColor.h"
#include "core/SkColorFilter.h"
#include "core/SkColorPriv.h"
#include "core/SkColorTable.h"
#include "core/SkData.h"
#include "core/SkDataTable.h"
#include "core/SkDeque.h"
#include "core/SkDevice.h"
#include "core/SkDocument.h"
#include "core/SkDraw.h"
#include "core/SkDrawFilter.h"
#include "core/SkDrawLooper.h"
#include "core/SkDrawable.h"
#include "core/SkFilterQuality.h"
#include "core/SkFlattenable.h"
#include "core/SkFlattenableSerialization.h"
#include "core/SkFont.h"
#include "core/SkFontLCDConfig.h"
#include "core/SkFontStyle.h"
#include "core/SkGraphics.h"
#include "core/SkImageEncoder.h"
#include "core/SkImageFilter.h"
#include "core/SkImageGenerator.h"
#include "core/SkMallocPixelRef.h"
#include "core/SkMask.h"
#include "core/SkMaskFilter.h"
#include "core/SkMath.h"
#include "core/SkMatrix.h"
#include "core/SkMetaData.h"
#include "core/SkMilestone.h"
#include "core/SkMultiPictureDraw.h"
#include "core/SkOSFile.h"
#include "core/SkPath.h"
#include "core/SkPathEffect.h"
#include "core/SkPathMeasure.h"
#include "core/SkPathRef.h"
#include "core/SkPicture.h"
#include "core/SkPictureRecorder.h"
#include "core/SkPixelRef.h"
#include "core/SkPixelSerializer.h"
#include "core/SkPixmap.h"
#include "core/SkPngChunkReader.h"
#include "core/SkPoint.h"
#include "core/SkPoint3.h"
#include "core/SkPostConfig.h"
#include "core/SkPreConfig.h"
#include "core/SkRRect.h"
#include "core/SkRSXform.h"
#include "core/SkRWBuffer.h"
#include "core/SkRasterizer.h"
#include "core/SkRect.h"
#include "core/SkRefCnt.h"
#include "core/SkRegion.h"
#include "core/SkScalar.h"
#include "core/SkShader.h"
#include "core/SkSize.h"
#include "core/SkStream.h"
#include "core/SkString.h"
#include "core/SkStrokeRec.h"
#include "core/SkSurfaceProps.h"
#include "core/SkSwizzle.h"
#include "core/SkTLazy.h"
#include "core/SkTRegistry.h"
#include "core/SkTextBlob.h"
#include "core/SkTime.h"
#include "core/SkTraceMemoryDump.h"
#include "core/SkTypeface.h"
#include "core/SkTypes.h"
#include "core/SkUnPreMultiply.h"
#include "core/SkWriteBuffer.h"
#include "core/SkWriter32.h"
#include "core/SkYUVSizeInfo.h"
#endif
