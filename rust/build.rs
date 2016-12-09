fn main() {
    println!("cargo:rustc-link-search=native=c:/proj/g/skia/out/Static");
    println!("cargo:rustc-link-lib=static=skia");
    println!("cargo:rustc-link-lib=user32");
    println!("cargo:rustc-link-lib=opengl32");
}
