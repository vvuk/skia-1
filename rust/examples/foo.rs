extern crate skia;

use std::ptr;

use skia::skia_bind;

fn main() {
    unsafe {
        let image_info = skia_bind::SkImageInfo::MakeS32(100, 100, skia_bind::SkAlphaType::kPremul_SkAlphaType);
        let surface = skia_bind::SkSurface::MakeRaster(&image_info, 0, ptr::null());
    }
}
