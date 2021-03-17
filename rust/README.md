Intergration to flutter by link:
https://dev.to/sunshine-chain/dart-meets-rust-a-match-made-in-heaven-9f5

iOS:
cargo install cargo-lipo

android:
cargo install cargo-ndk
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android

cd native/adder-ffi
cargo ndk -t armeabi-v7a -t arm64-v8a -o ./jniLibs build --release 

cp -r ./jniLibs ../../flutter/android/app/src/main/
