import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

import 'package:flutter_svg/svg.dart';

import 'package:nirmiti_app/Screens/AddLeads.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:path_provider/path_provider.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class allcalls extends StatefulWidget {
  _allcalls createState() => _allcalls();
}

class _allcalls extends State<allcalls> {
  var base64File;
  var filename1;
  Iterable<CallLogEntry>? _callLogs;
  //final CallRecorderService _recorderService = CallRecorderService();
  var postedTimestamps;
  var a;
  List<FileSystemEntity> _recordings = [];
  List<FileSystemEntity> recordings = [];
  List<Object?> recordings1 = [];
  bool _isPicking = false;
  var date, time, calldate;

  List<Object?> recordings_1 = [];
  @override
  void initState() {
    super.initState();
    fetchCallLogs();
    //requestManageStoragePermission();
    fetchAndPostCallLogsWithoutfile();
    changefileName();
  }

  String formatDuration(var seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  DateTime? extractDateTimeFromFilename(String filename) {
    // Extract date and time substring from the filename
    final regex = RegExp(r'_(\d{6})_(\d{6})'); // Pattern for 'YYMMDD_HHMMSS'
    final match = regex.firstMatch(filename);

    if (match != null) {
      // Get date and time parts from the filename
      final String datePart = match.group(1)!; // e.g., '241008'
      final String timePart = match.group(2)!; // e.g., '124259'
      time = timePart;
      // Parse date and time into a DateTime object
      final String formattedDate =
          '20${datePart.substring(0, 2)}-${datePart.substring(2, 4)}-${datePart.substring(4, 6)}';
      DateTime parsedDate = DateTime.parse(
          '20${datePart.substring(0, 2)}-${datePart.substring(2, 4)}-${datePart.substring(4, 6)}');

      // Format the date as MMddyy
      String formattedDate1 = DateFormat('dd-MM-yyyy').format(parsedDate);
      calldate = formattedDate1;
      final String formattedTime =
          '${timePart.substring(0, 2)}:${timePart.substring(2, 4)}:${timePart.substring(4, 6)}';

      final DateTime dateTime = DateTime.parse('$formattedDate $formattedTime');
      date = formattedTime;
      return dateTime;
    }
    return null;
  }

  Future<void> changefileName() async {
    final token = await SessionManager.getToken();
    Iterable<CallLogEntry> callLogs = await CallLog.get();
    Directory appDocDir = Directory('/storage/emulated/0/Nirmiti/');
    Directory appDocDir1 = Directory('/storage/emulated/0/Recordings/Call/');
    if (await appDocDir1.exists()) {
      List<FileSystemEntity> files = appDocDir1.listSync().toList();

      if (files.isEmpty) {
        print("No Files Available");
      } else {
        for (int i = 0; i < files.length; i++) {
          var filepath = files[i];
          var newfile = files[i].path.split('/').last;
          String fileName = newfile.toString();
          File file = File(appDocDir1.path);
          final DateTime? dateTime = extractDateTimeFromFilename(fileName);
          //  if (dateTime != null) {
          // String formattedDate =
          //     DateFormat('dd-MM-yyyy_HH-mm-ss').format(dateTime);
          // String newFileName = 'Callrecording_${formattedDate}';
          //String newPath = p.join(p.dirname(appDocDir.path), newFileName);
          // Directory? apptempDir = await getExternalStorageDirectory();
          // String newDir = p.join(apptempDir!.path, newFileName);

          for (var file1 in files) {
            if (await file1.exists()) {
              if (date != null) {
                for (CallLogEntry entry in callLogs) {
                  if (entry.callType == CallType.rejected) {
                    //break;
                  } else if (entry.callType == CallType.missed) {
                    //break;
                  } else if (entry.callType == CallType.outgoing &&
                      entry.duration == 0) {
                    //break;
                  } else {
                    var callingtime1 =
                        formatTimestampforpostaudio(entry.timestamp);
                    var currentcallingDate =
                        formatcurrentcalldate(entry.timestamp);
                    if (calldate == currentcallingDate) {
                      var timevalue1;
                      var timeValue = int.parse(time) - int.parse(callingtime1);
                      if (timeValue < 0) {
                        timeValue = 0;
                      } else {
                        timevalue1 = int.parse(time) - timeValue;
                      }
                      if (int.parse(callingtime1) == timevalue1) {
                        var t1 = timevalue1.toString();
                        var finalcalltime = int.parse(callingtime1) + timeValue;
                        String timePart;
                        if (finalcalltime.toString().length == 5) {
                          var a = 0;
                          timePart = a.toString() + finalcalltime.toString();
                        } else {
                          timePart = finalcalltime.toString();
                        }

                        // Adjust the matching threshold if needed (e.g., +-1 minute)
                        var currentcallrecordingtiming =
                            '${time.substring(0, 2)}:${time.substring(2, 4)}:${time.substring(4, 6)}';
                        // var currentcalltime =
                        //     '${timePart.substring(0, 2)}:${timePart.substring(2, 4)}:${timePart.substring(4, 6)}';
                        if (time == timePart) {
                          var callingtime =
                              '${callingtime1.substring(0, 2)}-${callingtime1.substring(2, 4)}-${callingtime1.substring(4, 6)}';
                          // String formattedDate =
                          //     DateFormat('dd-MM-yyyy_HH-mm-ss').format(dateTime);
                          String newFileName1 =
                              'Callrecording_${calldate}_${callingtime}';
                          String? mobileNo = entry.number;
                          if (mobileNo != null && mobileNo.startsWith('+91')) {
                            mobileNo = mobileNo.substring(3);
                          } else {
                            mobileNo;
                          }
                          String newFileName =
                              'Callrecording_${mobileNo}_${calldate}_${callingtime}.wav';
                          if (await file1.exists()) {
                            final File audioFile = File(files[i].path);
                            List<int> fileBytes = await audioFile.readAsBytes();
                            base64File = base64Encode(fileBytes);
                            print("File" + base64File);

                            List<Map<String, dynamic>> audiolist = files
                                .map((entry) {
                                  {
                                    return {
                                      "file_name": newFileName,
                                      "file_base64": base64File
                                    };
                                  }
                                })
                                .cast<Map<String, dynamic>>()
                                .toList();
                            // await file.delete();
                            final url = Uri.parse(
                                'https://nirmitiapps.in:3000/api/call-log');
                            final response = await http.put(
                              url,
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                              body: jsonEncode(audiolist[0]),
                            );
                            print(response.body);
                            if (response.statusCode == 200) {
                              file1.delete();
                              setState(() {
                                files.clear();
                                files = appDocDir1.listSync().toList();
                                files.length;
                                audiolist.clear();
                              });

                              print("Call recording files updated");

                              // showAlertAndNavigateToLogin(context);
                            }

                            // Exit the loop once a match is found
                          }
                        } else {
                          print("no audio file available");
                        }
                      } else {
                        print("No mathcing Time found");
                      }
                    } else {
                      print("No matching date found");
                    }
                  }
                }
              } else {
                print("No files Found");
              }
            } else {
              print("no audio file available");
            }

            break;
          }
          //break;
        }
      }
    } else if (await appDocDir.exists()) {
      List<FileSystemEntity> files = appDocDir.listSync().toList();
      if (files.isEmpty) {
        print("No Files Available");
      } else {
        for (int i = 0; i < files.length; i++) {
          var filepath = files[i];
          var newfile = files[i].path.split('/').last;
          String fileName = newfile.toString();
          File file = File(appDocDir.path);
          // String fileName = p.basename(file.path);
          String fileExtension = p.extension(file.path);
          RegExp regExp = RegExp(r'\d+');
          var match = regExp.firstMatch(fileName);

          if (match != null) {
            String numberString = match.group(0) ?? '';
            int timestamp = int.parse(numberString);
            formatTimestamp(timestamp);
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            String formattedDate =
                DateFormat('dd-MM-yyyy_HH-mm-ss').format(dateTime);
            String newFileName = 'Callrecording_${formattedDate}.wav';
            //String newPath = p.join(p.dirname(appDocDir.path), newFileName);
            Directory? apptempDir = await getExternalStorageDirectory();
            String newDir = p.join(apptempDir!.path, newFileName);
            for (var file in files) {
              String fileName = p.basenameWithoutExtension(file.path);

              //DateTime fileTimestamp = DateTime.parse(timestamp);

              // Match with call logs by timestamp
              for (CallLogEntry entry in callLogs) {
                DateTime callTimestamp =
                    DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);

                // Adjust the matching threshold if needed (e.g., +-1 minute)
                if ((callTimestamp.difference(dateTime).inSeconds).abs() <=
                    60) {
                  String? mobileNo = entry.number;
                  if (mobileNo != null && mobileNo.startsWith('+91')) {
                    mobileNo = mobileNo.substring(3);
                  } else {
                    mobileNo;
                  }
                  String newFileName =
                      'Callrecording_${mobileNo}_${formattedDate}.wav';
                  //String newFilePath = p.join(apptempDir.path, newFileName);
                  String newFilePath1 =
                      '${apptempDir.path}/${newFileName}'; // New file path in target directory
                  File newFile = await File(file.path).copy(newFilePath1);

                  // print('Copied file: ${file.path} to $newFilePath1');
                  // print('Moved file: ${file.path} to $newFilePath1');

                  // print('File renamed to: $newFilePath1');

                  await file.delete();

                  break; // Exit the loop once a match is found
                }
              }
            }
            // fetchAndPostCallLogswithfile();
            print('Original Filename: $fileName');
            print('Converted Timestamp: $formattedDate');
          } else {
            print('No numbers found in the filename.');
          }
        }
      }
    }

    Directory? tempDir = await getExternalStorageDirectory();
    List<FileSystemEntity> tempfiles = tempDir!.listSync().toList();
    if (tempfiles.isEmpty) {
      print("No audio Files availble");
      // Fluttertoast.showToast(
      //     msg: "No audio Files available",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 10,
      //     backgroundColor: Colors.amber[200],
      //     textColor: MyColors.themecolor,
      //     fontSize: 12.0);
    } else {
      for (int i = 0; i < tempfiles.length; i++) {
        var fileName = tempfiles[i].path.split('/').last;
        final File audioFile = File(tempfiles[i].path);
        List<int> fileBytes = await audioFile.readAsBytes();
        base64File = base64Encode(fileBytes);
        print("File" + base64File);
        for (var file in tempfiles) {
          List<Map<String, dynamic>> audiolist = tempfiles
              .map((entry) {
                {
                  return {"file_name": fileName, "file_base64": base64File};
                }
              })
              .cast<Map<String, dynamic>>()
              .toList();
          // await file.delete();
          final url = Uri.parse('https://nirmitiapps.in:3000/api/call-log');
          final response = await http.put(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(audiolist[0]),
          );
          print(response.body);
          if (response.statusCode == 200) {
            await file.delete();
            // Fluttertoast.showToast(
            //     msg: "Call recording files update sucees",
            //     toastLength: Toast.LENGTH_LONG,
            //     gravity: ToastGravity.CENTER,
            //     timeInSecForIosWeb: 20,
            //     backgroundColor: Colors.amber[200],
            //     textColor: MyColors.themecolor,
            //     fontSize: 12.0);
            print("Call recording files update sucees");
            // showAlertAndNavigateToLogin(context);
          }
        }
      }
    }
  }

  void fetchAndPostCallLogsWithoutfile() async {
    final token = await SessionManager.getToken();
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
      if (response.statusCode == 401) {
        print("Call post success");
        showAlertAndNavigateToLogin(context);
      }
    }
  }

  void fetchAndPostCallLogswithfile() async {
    final token = await SessionManager.getToken();
    //Directory? appDocDir = await getExternalStorageDirectory();
    Directory appDocDir = Directory('/storage/emulated/0/Recordings/Call/');

    if (await appDocDir.exists()) {
      // Get the app's document directory (or previously created folder path)
      List<FileSystemEntity> files = appDocDir.listSync().toList();
      if (files.isEmpty) {
        print("No files available");
        DateTime endTime = DateTime.now();
        DateTime startTime =
            endTime.subtract(Duration(hours: 12)); // Start time
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
              } else if (entry.callType == CallType.missed) {
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
              } else if (entry.callType == CallType.rejected) {
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
              } else {
                // return "No Data Available";

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
          if (response.statusCode == 401) {
            showAlertAndNavigateToLogin(context);
          }
        }
      } else {
        for (var file in files) {
          setState(() {
            recordings = appDocDir.listSync().toList();
            recordings.sort((a, b) {
              return b.statSync().modified.compareTo(a.statSync().modified);
            });
          });

          var audioFileName = recordings[0].path.split('/').last;
          filename1 = audioFileName;
          final File audioFile = File(recordings[0].path);
          List<int> fileBytes = await audioFile.readAsBytes();
          base64File = base64Encode(fileBytes);
          print("File" + base64File);

          DateTime endTime = DateTime.now();
          DateTime startTime =
              endTime.subtract(Duration(hours: 12)); // Start time
          // Fetch call logs
          Iterable<CallLogEntry> entries = await CallLog.get();
          print(startTime);
          print(endTime);
          // Prepare data for posting
          List<Map<String, dynamic>> callLogs = entries
              .where((entry) {
                DateTime callDate = DateTime.fromMillisecondsSinceEpoch(
                    entry.timestamp!.toInt());
                return callDate.isAfter(startTime) &&
                    callDate.isBefore(endTime);
              })
              .map((entry) {
                var mobileNo;
                if (entry.number!.startsWith('+91')) {
                  mobileNo = entry.number!.substring(3);
                } else {
                  mobileNo = entry.number;
                }
                if (entry.callType == CallType.outgoing &&
                    entry.duration == 0) {
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
                } else if (entry.callType == CallType.missed) {
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
                } else if (entry.callType == CallType.rejected) {
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
                return {
                  "mobile_number": mobileNo,
                  "customer_name": entry.name == "" ? 'Unknown' : entry.name,
                  "calling_type": getTextForCallType(entry.callType),
                  "call_time": formatTimestamp(entry.timestamp),
                  "call_date": formatdate(entry.timestamp),
                  "call_duration": formatDuration(entry.duration),
                  "file_name": filename1 == null ? "" : filename1,
                  "file_base64": base64File == null ? "-" : base64File
                };
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
              //  print("Call post success outgoing");
              showAlertAndNavigateToLogin(context);
            }
          }
          await file.delete();
        }
      }
    }
  }

  String formatdate(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('yyyy-MM-dd').format(dateIst);
  }

  String formatcurrentcalldate(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd-MM-yyyy').format(dateIst);
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm:ss').format(dateIst);
  }

  String formatTimestampforpostaudio(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HHmmss').format(dateIst);
  }

  Future<void> fetchCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    setState(() {
      _callLogs = entries;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void dispose() {
    //_phoneStateSubscription!.cancel();
    // _intentDataStreamSubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Form(
      child: Column(
        children: [
          // Container(
          //     height: 200,
          //     child: ListView.builder(
          //       itemCount: recordings.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(title: Text(recordings_1[index].toString()));
          //       },
          //     )),
          _callLogs == null
              ? Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                      child: Text("No Data Found",
                          style: TextStyle(
                              fontFamily: "Causten-bold",
                              fontSize: 15,
                              color: MyColors.themecolor))),
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: RefreshIndicator(
                    onRefresh: fetchCallLogs,
                    child: ListView.builder(
                      itemCount: _callLogs!.length,
                      itemBuilder: (context, index) {
                        CallLogEntry entry = _callLogs!.elementAt(index);
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 0.1,
                                    ),
                                  ]),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: SvgPicture.asset(
                                        getImageForCallType(entry.callType)),
                                    title: entry.name == ""
                                        ? Text('Unknown',
                                            style: TextStyle(
                                              fontFamily: "Causten-semiBold",
                                              fontSize: 18,
                                            ))
                                        : Text(
                                            entry.name ??
                                                entry.number ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontFamily: "Causten-SemiBold",
                                              fontSize: 18,
                                            )),
                                    subtitle: Container(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(entry.number.toString(),
                                              style: TextStyle(
                                                fontFamily: "Causten-Regular",
                                                fontSize: 12,
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '${formatTimestamp(entry.timestamp)}',
                                            style: TextStyle(
                                              fontFamily: "Causten-Regular",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                      height: 50,
                                      child: InkWell(
                                          onTap: () {
                                            _makePhoneCall(entry.number!);
                                          },
                                          child: SvgPicture.asset(
                                              "asset/Images/call.svg")),
                                    ),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => addLead()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: MyColors.themecolor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      height: 30,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Tap to add leads",
                                              style: TextStyle(
                                                  fontFamily: "Causten-Regular",
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    ));
  }

  void showAlertAndNavigateToLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Session Expired',
                style: TextStyle(
                    fontFamily: "Causten-Bold",
                    fontSize: 20,
                    color: Colors.red)),
          ),
          content: Text('Your session has expired. Please login again.',
              style: TextStyle(fontFamily: "Causten-semiBold", fontSize: 15)),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style: TextStyle(fontFamily: "Causten-Bold", fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
                SessionManager.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  String getImageForCallType(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return "asset/Images/income.svg";
      case CallType.outgoing:
        return "asset/Images/out.svg";
      case CallType.missed:
        return "asset/Images/missed.svg";
      case CallType.rejected:
        return "asset/Images/reject.svg";
      default:
        return "asset/Images/all.svg";
    }
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
}
