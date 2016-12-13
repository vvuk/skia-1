extern crate skia;

use std::ptr;

use skia::*;

fn main() {
    unsafe {
        let image_info = SkImageInfo::MakeS32(100, 100, SkAlphaType::kPremul_SkAlphaType);
        let mut surface = SkSurface::MakeRaster(&image_info, 0, ptr::null());
        println!("surface: sk_sp addr: {:?} val: {:?}", &surface as *const _, surface);
        let canvas = (*surface).getCanvas();

        let r = SkRect { fLeft: 10., fTop: 10., fRight: 100., fBottom: 100. };
        let mut p = SkPaint::new();
        p.setARGB(0xff, 0xff, 0x00, 0x00);
        (*canvas).drawRect(&r, &p);
    }
}
