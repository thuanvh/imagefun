// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

// import 'dart:async';

// import 'package:flutter/services.dart';

// class Adder {
//   static const MethodChannel _channel =
//       const MethodChannel('adder');

//   static Future<String> get platformVersion async {
//     final String version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }
// }

import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';

typedef add_func = Int64 Function(Int64 a, Int64 b);
typedef process_image_func = Void Function(Pointer<Utf8>, Pointer<Utf8>);

typedef AddFunc = int Function(int a, int b);
typedef ProcessImageFunc = void Function(Pointer<Utf8>, Pointer<Utf8>);

DynamicLibrary load({String basePath = ''}) {
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('${basePath}libadder_ffi.so');
  } else if (Platform.isIOS) {
    // iOS is statically linked, so it is the same as the current process
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('${basePath}libadder_ffi.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('${basePath}libadder_ffi.dll');
  } else {
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  }
}

class NotSupportedPlatform implements Exception {
  NotSupportedPlatform(String s);
}

class Adder {
  static DynamicLibrary _lib;
  static AddFunc _sum;
  static ProcessImageFunc _processImageFunc;
  Adder() {
    if (_lib != null) return;
    // for debugging and tests
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _lib = load(basePath: '../../../target/debug/');
    } else {
      _lib = load();
    }

    // get a function pointer to the symbol called `add`
    final addPointer = _lib.lookup<NativeFunction<add_func>>('add');
    // and use it as a function
    _sum = addPointer.asFunction<AddFunc>();
    _processImageFunc = _lib
        .lookup<NativeFunction<process_image_func>>('process_image')
        .asFunction<ProcessImageFunc>();
  }

  int add(int a, int b) {
    return _sum(a, b);
  }

  void processImage(String inputPath, String outputPath) {
    _processImageFunc(StringUtf8Pointer(inputPath).toNativeUtf8(),
        StringUtf8Pointer(outputPath).toNativeUtf8());
  }
}
