#[no_mangle]
pub extern "C" fn add(a: i64, b: i64) -> i64{
    adder::add(a,b)
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
