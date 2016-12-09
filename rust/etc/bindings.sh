#!/bin/bash

#!/bin/bash

cd "$(dirname "$0")"

EXTRA_FLAGS=
EXTRA_CLANG_FLAGS=
if [[ "$1" == "msvc14" ]] ; then
    EXTRA_CLANG_FLAGS="--target=x86_64-pc-win32 -DWIN32=1"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -fms-compatibility-version=19.00"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -DEXPORT_JS_API=1 -D_CRT_USE_BUILTIN_OFFSETOF"
    EXTRA_CLANG_FLAGS="$EXTRA_CLANG_FLAGS -fvisibility=hidden"
fi

: ${BINDGEN:=../../../../r/rust-bindgen/target/debug/bindgen}

if [[ ! -x "$BINDGEN" ]]; then
    echo "error: BINDGEN does not exist or isn't executable!"
    echo "error: with BINDGEN=$BINDGEN"
    exit 1
fi

FILES=(
    SkCanvas.h
    SkPaint.h
)

WHITELISTED_TYPES=(
    SkCanvas
    SkImageInfo
    SkPaint
    SkSurface
    SkTime
    SkTime::DateTime
)

WHITELISTED_FN_REGEX=(
    'Sk.*'
)

BLACKLISTED_TYPES=(
    'is_bitmask_enum'
)


$BINDGEN \
  ${EXTRA_FLAGS} \
  ${BLACKLISTED_TYPES[@]/#/--blacklist-type } \
  ${WHITELISTED_TYPES[@]/#/--whitelist-type } \
  ${WHITELISTED_FN_REGEX[@]/#/--whitelist-function } \
  --bitfield-enum 'Gr.*Flags' \
  --bitfield-enum 'Sk.*Flags' \
  -o skia_bind.rs \
  skia_includes.h \
  -- \
  ${EXTRA_CLANG_FLAGS} \
  -DRUST_BINDGEN=1 \
  -x c++ --std=c++11 \
  -I ../../include \
  -I ../../include/config \
|| exit 1

echo
echo Post-processing...

# post-process some things
sed -i 's|, \.\.\.||g' skia_bind.rs
sed -i 's|//!|//|g' skia_bind.rs

cp skia_bind.rs ../src

echo Done

