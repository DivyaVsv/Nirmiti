import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nirmiti_app/Screens/AddLeads.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> fetchCallLogs() async {
  // Request permission
  var status = await Permission.phone.request();
  if (status.isGranted) {
    // Fetch call logs
    Iterable<CallLogEntry> entries = await CallLog.get();
    entries.forEach((entry) {
      print('Fetched call log: ${entry}');
    });
  } else {
    print('Permission not granted');
  }
}

class rejectedcalls extends StatefulWidget {
  _rejectedcalls createState() => _rejectedcalls();
}

class _rejectedcalls extends State<rejectedcalls> {
  Iterable<CallLogEntry>? _callLogs;

  @override
  void initState() {
    super.initState();
    fetchCallLogs();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm').format(dateIst);
  }

  Future<void> fetchCallLogs() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      Iterable<CallLogEntry> entries = await CallLog.get();
      setState(() {
        _callLogs =
            entries.where((entry) => entry.callType == CallType.rejected);
      });
    } else {
      print('Permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _callLogs == null
            ? Container(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                    child: Text("No Data Found",
                        style: TextStyle(
                            fontFamily: "Causten-Bold",
                            fontSize: 15,
                            color: MyColors.themecolor))),
              )
            : Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.builder(
                  itemCount: _callLogs!.length,
                  itemBuilder: (context, index) {
                    CallLogEntry entry = _callLogs!.elementAt(index);
                    if (CallType.rejected == []) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                            child: Text("No Data Found",
                                style: TextStyle(
                                    fontFamily: "Causten-Bold",
                                    fontSize: 15,
                                    color: MyColors.themecolor))),
                      );
                    } else {
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
                                  title: entry.name == null
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
                                            bottomRight: Radius.circular(10))),
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
                    }
                  },
                ),
              ),
      ],
    ));
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
}
