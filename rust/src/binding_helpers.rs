use std::ptr;
use std::ops::{Deref, DerefMut};
use std::sync::atomic::{AtomicU32, Ordering};

#[repr(C)]
pub struct SkRefCntBase__bindgen_vtable {
}

#[repr(C)]
#[derive(Debug)]
pub struct SkRefCntBase {
    pub vtable_: *const SkRefCntBase__bindgen_vtable,
    pub fRefCnt: AtomicU32,
}

#[test]
fn bindgen_test_layout_SkRefCntBase() {
    assert_eq!(::std::mem::size_of::<SkRefCntBase>() , 16usize);
    assert_eq!(::std::mem::align_of::<SkRefCntBase>() , 8usize);
}

// This sk_sp implementation is *only* useful for return values from
// native functions, or for creating on the Rust side.  The "dummy"
// member is not present in the C++ version.
//
// It's done this way to work around a Rust compiler issue that causes
// a MSVC ABI mismatch -- C++ struct returns are done in a register if
// they fit *and* are essentially a POD type (no constructors etc.).
// sk_sp<T> normally fits, but is not a POD type.
#[repr(C)]
#[derive(Debug)]
pub struct sk_sp<T> {
    pub ptr: *mut T,
    pub dummy: *mut ::std::os::raw::c_void,
}

impl<T> Clone for sk_sp<T> {
    fn clone(&self) -> Self {
        let new_sp = sk_sp { ptr: self.ptr, dummy: ptr::null_mut() };
        if !new_sp.ptr.is_null() {
            unsafe {
                let skbase = new_sp.ptr as *mut SkRefCntBase;
                (*skbase).fRefCnt.fetch_add(1, Ordering::Relaxed);
            }
        }
        new_sp
    }
}

impl<T> Drop for sk_sp<T> {
    fn drop(&mut self) {
        println!("sk_sp drop: this: {:?} ptr: {:?}", &self as *const _, self.ptr);
        if !self.ptr.is_null() {
            unsafe {
                let skbase = self.ptr as *mut SkRefCntBase;
                println!("sk_sp drop: skbase: {:?} refcnt: {:?}", skbase, (*skbase).fRefCnt);
                let new_refcnt = (*skbase).fRefCnt.fetch_sub(1, Ordering::AcqRel);
                if new_refcnt == 0 {
                    println!("Rust sk_sp<T> dropped; new refcnt is 0, but I don't know how to delete things!");
                }
            }
        }
    }
}

impl<T> Deref for sk_sp<T> {
    type Target = T;

    fn deref(&self) -> &T {
        unsafe {
            &*self.ptr
        }
    }
}

impl<T> DerefMut for sk_sp<T> {
    fn deref_mut(&mut self) -> &mut T {
        unsafe {
            &mut *self.ptr
        }
    }
}
