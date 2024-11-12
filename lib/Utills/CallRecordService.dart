import 'package:flutter/services.dart';

class CallRecordService {
  static const platform =
      MethodChannel('com.example.nirmiti_app/callRecording');

  Future<void> startRecording() async {
    try {
      await platform.invokeMethod('startRecording');
      print("Start REcording");
    } on PlatformException catch (e) {
      print("Failed to start recording: '${e.message}'.");
    }
  }

  Future<void> stopRecording() async {
    try {
      await platform.invokeMethod('stopRecording');
      print("STop REcording");
    } on PlatformException catch (e) {
      print("Failed to stop recording: '${e.message}'.");
    }
  }
}
