use std::ffi::CString;
use std::ffi::OsStr;
use std::ffi::CStr;
use std::os::raw::c_char;
use std::fs;
use std::path::Path;

#[no_mangle]
pub extern "C" fn add(a: i64, b: i64) -> i64{
    adder::add(a,b)
}

#[cfg(unix)]
fn path_to_bytes<P: AsRef<Path>>(path: P) -> Vec<u8>{
    use std::os::unix::ffi::OsStrExt;
    path.as_ref().as_os_str().as_bytes().to_vec()
}

#[cfg(not(unix))]
fn path_to_bytes<P: AsRef<Path>>(path: P) -> Vec<u8>{
    path.as_ref().to_string_lossy().to_string().into_bytes()
}

#[cfg(unix)]
fn bytes_to_path(str_input: *mut c_char) -> &'static OsStr{
    unsafe{
        use std::os::unix::ffi::OsStrExt;
        OsStr::from_bytes(CStr::from_ptr(str_input).to_bytes())
        //Path::new(osc_fi)
        //osc_fi
    }
}

#[cfg(not(unix))]
fn bytes_to_path(str_input: *mut c_char) -> &'static OsStr{
    unsafe{
        let str2 = ::std::str::from_utf8( CStr::from_ptr(str_input).to_bytes()).expect("need utf8");
    //let osc_fi = OsStr::from_bytes(str2)
    //let o : &Path = str2.as_ref();//Path::new(osc_fi)
    //Path::new(str2)
        str2.as_ref()
    }
}

#[no_mangle]
pub extern "C" fn process_image(input_file: *mut c_char, output_file: *mut c_char) {
    unsafe{
        if input_file.is_null() {return}
        // let fi = CString::from_raw(input_file).as_c_str();
        // let fo = CString::from_raw(output_file).as_c_str();

        // let osc_fi = OsStr::from_bytes()
        // fs::copy(input_file, output_file);
        fs::copy(bytes_to_path(input_file), bytes_to_path(output_file));
        let f : str = str::from_ptr(input_file);
        imread(f);
    };
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
