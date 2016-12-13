#!/bin/bash

TARGET=$1

cd "$(dirname "$0")"

: ${BINDGEN:=/c/proj/r/rust-bindgen/target/debug/bindgen}
#: ${BINDGEN:=/home/emilio/projects/moz/rust-bindgen/target/debug/bindgen}

EXTRA_FLAGS=
EXTRA_CLANG_FLAGS=

if [[ "$TARGET" == "msvc14" ]] ; then
    EXTRA_CLANG_FLAGS="--target=x86_64-pc-win32 -DWIN32=1"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -fms-compatibility-version=19.00"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -DEXPORT_JS_API=1 -D_CRT_USE_BUILTIN_OFFSETOF"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -Wno-microsoft-include"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -Wno-expansion-to-defined"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -Wno-microsoft-enum-value"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -Wno-ignored-attributes"
fi


if [[ ! -x "$BINDGEN" ]]; then
    echo "error: BINDGEN does not exist or isn't executable!"
    echo "error: with BINDGEN=$BINDGEN"
    exit 1
fi

zWHITELISTED_TYPES=(
    SkPaint
)

WHITELISTED_TYPES=(
    SkCanvas
    SkImageInfo
    SkPaint
    SkRefCnt
    SkSurface
    SkTypeface
    SkPathEffect
    SkShader
    SkMaskFilter
    SkColorFilter
    SkRasterizer
    SkDrawLooper
    SkShader
    SkPathEffect
    SkTypeface
    SkShader_TileMode
    SkClipStack
)

WHITELISTED_FN_REGEX=(
#    'SkImageInfo::MakeN32'
)

BLACKLISTED_TYPES=(
    'std::unique_ptr__Pointer_type'
    'std::unique_ptr___tuple_type'
    'std::tuple_Inherited'
    'is_bitmask_enum'
    'SkRefCntBase'
)

OPAQUE_TYPES=(
    'std::atomic'
)

set -x
$BINDGEN \
  ${EXTRA_FLAGS} \
  ${BLACKLISTED_TYPES[@]/#/--blacklist-type } \
  ${WHITELISTED_TYPES[@]/#/--whitelist-type } \
  ${WHITELISTED_FN_REGEX[@]/#/--whitelist-function } \
  ${OPAQUE_TYPES[@]/#/--opaque-type } \
  --enable-cxx-namespaces \
  --raw-line 'pub use self::root::*;' \
  --bitfield-enum 'Gr.*Flags' \
  --bitfield-enum 'Sk.*Flags' \
  -o skia_bind.rs \
  skia_includes.hpp \
  -- \
  $EXTRA_CLANG_FLAGS \
  -I "/c/Program Files (x86)/Windows Kits/10/Include/10.0.14393.0/ucrt/" \
  -DRUST_BINDGEN=1 \
  -x c++ -std=c++14 \
  -I ../../include \
  -I ../../include/core \
  -I ../../include/config \
2>warnings.txt || exit 1
set +x

echo `wc -l warnings.txt` lines of warnings generated \(see warnings.txt\)
echo Post-processing...

# post-process some things
sed -i 's|pub type atomic__My_base.*||' skia_bind.rs
sed -i 's|, \.\.\.||g' skia_bind.rs
sed -i 's|//!|//|g' skia_bind.rs
sed -i 's|pub mod root {|pub mod root { use binding_helpers::{SkRefCntBase, sk_sp};|g' skia_bind.rs
sed -i 's|pub struct sk_sp|pub struct sk_sp_ignore_this_one|g' skia_bind.rs

mv skia_bind.rs ../src/bindings.rs

echo Done

