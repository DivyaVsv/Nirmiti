import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;
import 'package:app_settings/app_settings.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Screens/DefaultappSet.dart';
import 'package:nirmiti_app/Screens/login.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:phone_state/phone_state.dart';

class splash extends StatefulWidget {
  _splash createState() => _splash();
}

class _splash extends State<splash> with WidgetsBindingObserver {
  var userid;
  List<FileSystemEntity> _recordings = [];
  var base64File;
  var filename1;
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _filePath;
  List<FileSystemEntity> recordings = [];
  // final CallRecordService _service = CallRecordService();
  static const platform =
      MethodChannel('com.example.nirmiti_app/callRecording');

  Future<void> bringAppToForeground() async {
    try {
      final folderPath =
          '/storage/emulated/0/Nirmiti'; // Replace with your folder path
      checkForNewFileInFolder();
      storagePermission();
      await platform.invokeMethod('backToForeground');
    } on PlatformException catch (e) {
      print("Failed to bring app to foreground: '${e.message}'.");
    }
  }

  Future<void> storagePermission() async {
    if (Permission.storage.isGranted == true) {
      print("Permission Granted for storage");
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.device);
    }
  }

  Future<void> _checkPermissionAndNavigate() async {
    // Check for a specific permission, e.g., location permission
    PermissionStatus status = await Permission.phone.status;
    if (status.isGranted) {
      // Permission is granted, navigate to another page

      SessionManager.isUserLogin().then((value) => {
            if (value == true)
              {
                SessionManager.getUser().then((id) => {
                      userid = id.employee_id,
                      if (userid == id.employee_id)
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => dashboard()),
                          );
                        })
                    })
              }
            else
              {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                })
              }
          });
    } else if (status.isDenied) {
      // Permission denied, show a message or handle accordingly

      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => defaultAPP()),
        );
      });
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings
      openAppSettings();
    }
  }

  Future<void> _loadRecordings() async {
    final persistentDirPath = await getPersistentDirectoryPath();
    final dir = Directory(persistentDirPath);

    setState(() {
      _recordings = dir.listSync().toList();

      // Convert the file to Base64 string
    });
  }

  Future<String> getPersistentDirectoryPath() async {
    final directory = await getExternalStorageDirectory();
    return '${directory!.path}';
  }

  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionAndNavigate();

    createFolder();
  }

  Future<void> createFolder() async {
    if (Permission.storage.isDenied == true) {
      //AppSettings.openAppSettings(type: AppSettingsType.device);
      Permission.storage.request();
    } else {
      // Define the new folder path

      final folderPath = '/storage/emulated/0/Nirmiti';

      // Create the folder if it doesn't exist
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
        print('Folder created: $folderPath');
      } else {
        print('Folder already exists: $folderPath');
      }
    }
  }

  Future<void> checkForNewFileInFolder() async {
    // final directory = Directory(folderPath);
    Directory? Dir = Directory('/storage/emulated/0/Nirmiti');

    if (await Dir.exists()) {
      Timer.periodic(Duration(seconds: 10), (timer) async {
        List<FileSystemEntity> files = Dir.listSync();

        // Check for any new files by comparing the file lists
        if (files.isNotEmpty) {
          print('Success: New file detected in folder.');
          fetchAndPostCallLogswithfile();
          timer.cancel(); // Stop checking once a new file is detected
        } else {
          fetchAndPostCallLogsWithoutfile();
          print('No new file found yet.');
        }
      });
    } else {
      print('Directory does not exist.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      print("App is inactive");
    }
    if (state == AppLifecycleState.hidden) {
      print("App is hide");
    }
    if (state == AppLifecycleState.resumed) {
      print("App is resume");
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => dashboard()));
      _checkPermissionAndNavigate();
    }
    if (state == AppLifecycleState.paused) {
      print("App is pause");
      PhoneState.stream.listen(
        (event) async {
          print(event.status);
          if (event.status == PhoneStateStatus.CALL_STARTED) {}
          if (event.status == PhoneStateStatus.CALL_INCOMING) {
            print("Incomming");

            //fetchAndPostCallLogs();
          }
          if (event.status == PhoneStateStatus.CALL_ENDED) {
            print("call end");
            fetchAndPostCallLogswithfile();
          }
        },
      );
    }

    super.didChangeAppLifecycleState(state);
  }

  Future<void> fetchAndPostCallLogsWithoutfile() async {
    final token = await SessionManager.getToken();
    // Define the source file (the call recording file)
    Directory appDocDir = Directory('/storage/emulated/0/Nirmiti');
    // Get the app's document directory (or previously created folder path)
    List<FileSystemEntity> files = appDocDir.listSync().toList();
    if (files.isEmpty) {
      print("No files available");
      DateTime endTime = DateTime.now();
      DateTime startTime = endTime.subtract(Duration(hours: 12)); // Start time
      // Fetch call logs
      Iterable<CallLogEntry> entries = await CallLog.get();
      print(startTime);
      print(endTime);
      // Prepare data for posting
      List<Map<String, dynamic>> callLogs = entries
          .where((entry) {
            DateTime callDate =
                DateTime.fromMillisecondsSinceEpoch(entry.timestamp!.toInt());
            return callDate.isAfter(startTime) && callDate.isBefore(endTime);
          })
          .map((entry) {
            if (entry.callType == CallType.outgoing && entry.duration == 0) {
              return {
                "mobile_number": entry.number,
                "customer_name": entry.name == "" ? 'Unknown' : entry.name,
                "calling_type": "NOT ATTENDED",
                "call_time": formatTimestamp(entry.timestamp),
                "call_date": formatdate(entry.timestamp),
                "call_duration": formatDuration(entry.duration),
                "file_name": "",
                "file_base64": ""
              };
            } else if (entry.callType == CallType.missed) {
              return {
                "mobile_number": entry.number,
                "customer_name": entry.name == "" ? 'Unknown' : entry.name,
                "calling_type": getTextForCallType(entry.callType),
                "call_time": formatTimestamp(entry.timestamp),
                "call_date": formatdate(entry.timestamp),
                "call_duration": formatDuration(entry.duration),
                "file_name": "",
                "file_base64": "",
              };
            } else if (entry.callType == CallType.rejected) {
              return {
                "mobile_number": entry.number,
                "customer_name": entry.name == "" ? 'Unknown' : entry.name,
                "calling_type": getTextForCallType(entry.callType),
                "call_time": formatTimestamp(entry.timestamp),
                "call_date": formatdate(entry.timestamp),
                "call_duration": formatDuration(entry.duration),
                "file_name": "",
                "file_base64": "",
              };
            } else {
              return {
                "mobile_number": entry.number,
                "customer_name": entry.name == "" ? 'Unknown' : entry.name,
                "calling_type": getTextForCallType(entry.callType),
                "call_time": formatTimestamp(entry.timestamp),
                "call_date": formatdate(entry.timestamp),
                "call_duration": formatDuration(entry.duration),
                "file_name": "",
                "file_base64": "",
              };
            }
          })
          .cast<Map<String, dynamic>>()
          .toList();

      // Post data to API
      for (int i = 0; i < callLogs.length; i++) {
        final url = Uri.parse('https://nirmitiapps.in:3000/api/call-log');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(callLogs[i]),
        );
        if (response.statusCode == 401) {
          print("Call post success");
        }
      }
    }
  }

  void fetchAndPostCallLogswithfile() async {
    final token = await SessionManager.getToken();
    // Directory appDocDir = Directory('/storage/emulated/0/Nirmiti/');
    // if (await appDocDir.exists()) {
    //   // Get the app's document directory (or previously created folder path)
    //   List<FileSystemEntity> files = appDocDir.listSync().toList();
    // if (files.isEmpty) {
    //   print("No files available");
    DateTime endTime = DateTime.now();
    DateTime startTime = endTime.subtract(Duration(hours: 12)); // Start time
    // Fetch call logs
    Iterable<CallLogEntry> entries = await CallLog.get();
    print(startTime);
    print(endTime);
    await Future.delayed(Duration(seconds: 10));
    // Prepare data for posting
    List<Map<String, dynamic>> callLogs = entries
        .where((entry) {
          DateTime callDate =
              DateTime.fromMillisecondsSinceEpoch(entry.timestamp!.toInt());
          return callDate.isAfter(startTime) && callDate.isBefore(endTime);
        })
        .map((entry) {
          var mobileNo = entry.number;
          if (mobileNo != null && mobileNo.startsWith('+91')) {
            mobileNo = mobileNo.substring(3);
          } else {
            mobileNo;
          }
          if (entry.callType == CallType.outgoing && entry.duration == 0) {
            return {
              "mobile_number": mobileNo,
              "customer_name": entry.name == "" ? 'Unknown' : entry.name,
              "calling_type": "NOT ATTENDED",
              "call_time": formatTimestamp(entry.timestamp),
              "call_date": formatdate(entry.timestamp),
              "call_duration": formatDuration(entry.duration),
              "file_name": "",
              "file_base64": ""
            };
          } else {
            return {
              "mobile_number": mobileNo,
              "customer_name": entry.name == "" ? 'Unknown' : entry.name,
              "calling_type": getTextForCallType(entry.callType),
              "call_time": formatTimestamp(entry.timestamp),
              "call_date": formatdate(entry.timestamp),
              "call_duration": formatDuration(entry.duration),
              "file_name": "",
              "file_base64": "",
            };
          }
        })
        .cast<Map<String, dynamic>>()
        .toList();

    // Post data to API
    for (int i = 0; i < callLogs.length; i++) {
      final url = Uri.parse('https://nirmitiapps.in:3000/api/call-log');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(callLogs[i]),
      );
      if (response.statusCode == 200) {
        print("Call post success");
        //showAlertAndNavigateToLogin(context);
      }
    }
  }

  String formatDuration(var seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatdate(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('yyyy-MM-dd').format(dateIst);
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm:ss').format(dateIst);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Container(
          color: MyColors.themecolor,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('asset/Images/Nirmiti.png')),
    );
  }

  String getTextForCallType(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return "INCOMING";
      case CallType.outgoing:
        return "OUTGOING";
      case CallType.missed:
        return "MISSED";
      case CallType.rejected:
        return "REJECTED";
      default:
        return "ALL";
    }
  }
  // static void startCallService() async {
  //   // Your call to start the background service
  //   var taskHandler = TaskHandler();
  //   FlutterForegroundTask.setTaskHandler(taskHandler);
  // }
}

// class MyTaskHandler implements FlutterForegroundTask {
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     // Implement background task logic if needed
//   }

//   Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {}

//   void onButtonPressed(String id) {}

//   void onNotificationPressed() {}
// }
