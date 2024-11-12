import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirmiti_app/Model/Leads.dart';
import 'package:nirmiti_app/Repo/LeadsListRepo.dart';
import 'package:nirmiti_app/Screens/AddLeads.dart';
import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Screens/FollowupDetail.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/Super_Responce.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class followup extends StatefulWidget {
  final token;
  followup({this.token});
  _followup createState() => _followup();
}

class _followup extends State<followup> {
  Iterable? data;
  var contactName;
  var contactNumber;
  var postedTimestamps;
  var myFormat = DateFormat('d-MM-yyyy');
  var followupdate;
  DateTime now = DateTime.now();

  String formatDuration(var seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> fetchAndPostCallLogs() async {
    final token = await SessionManager.getToken();

    // Request permissions
    var status = await Permission.phone.status;
    if (status.isDenied) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        // Permission not granted
        return;
      }
    }

    // Fetch call logs
    Iterable<CallLogEntry> entries = await CallLog.get();

    // Prepare data for posting
    List<Map<String, dynamic>> callLogs = entries
        .map((entry) {
          if (entry.callType == CallType.outgoing && entry.duration == 0) {
            return {
              "mobile_number": entry.number,
              "customer_name": entry.name == "" ? 'Unknown' : entry.name,
              "calling_type": "NOT ATTENDED",
              "call_time": formatTimestamp(entry.timestamp),
              "call_date": formatdate(entry.timestamp),
              "call_duration": formatDuration(entry.duration),
            };
          } else {
            return {
              "mobile_number": entry.number,
              "customer_name": entry.name == "" ? 'Unknown' : entry.name,
              "calling_type": getTextForCallType(entry.callType),
              "call_time": formatTimestamppostapi(entry.timestamp),
              "call_date": formatdate(entry.timestamp),
              "call_duration": formatDuration(entry.duration),
            };
          }
        })
        .cast<Map<String, dynamic>>()
        .toList();

    // Post data to API
    final url = Uri.parse('https://nirmitiapps.in:3000/api/call-log');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(callLogs[0]),
    );

    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: "Call Detail Add Succesfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 10,
      //     backgroundColor: Colors.amber.shade200,
      //     textColor: MyColors.themecolor,
      //     fontSize: 12.0);
    } else if (response.statusCode == 422) {
      // Fluttertoast.showToast(
      //     msg: response.body,
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 10,
      //     backgroundColor: Colors.amber.shade200,
      //     textColor: MyColors.themecolor,
      //     fontSize: 12.0);
    } else {
      Fluttertoast.showToast(
          msg: "Something Wrong.Please Wait",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.amber.shade200,
          textColor: MyColors.themecolor,
          fontSize: 12.0);
      // print('Failed to post call logs: ${response.body}');
      // throw Exception('Failed to post call logs');
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

  String formatTimestamppostapi(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm').format(dateIst);
  }

  Future<void> _contactSave() async {
    // Check for a specific permission, e.g., location permission
    PermissionStatus status = await Permission.contacts.status;

    if (status.isGranted) {
      // Permission is granted, navigate to another page
      Contact newContact = Contact(
        givenName: contactName,
        phones: [Item(label: 'mobile', value: contactNumber)],
      );

      // Save the contact
      await ContactsService.addContact(newContact);
      print('Contact saved successfully!');
    } else if (status.isDenied) {
      // Permission denied, show a message or handle accordingly
      await Permission.contacts.request();
      print('Permission denied');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    super.initState();
    fetchAndPostCallLogs();
  }

  String formattedDate = '';
  String getCurrentDate(var date) {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    return formattedDate.toString();
  }

  formatTimestamp(var timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    String time = timestamp.toString();
    var dateUtc = DateTime.parse(time);
    // Convert UTC to IST (IST is UTC+5:30)

    return DateFormat('dd-MM-yyyy').format(dateUtc);
  }

  void launchWhatsApp({required String phone, required String message}) async {
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Today Follow up",
            style: TextStyle(fontFamily: "Causten-Semibold", fontSize: 18),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: MyColors.boxcolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => dashboard()));
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f1.svg",
                      ),
                      Text("Call History",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addLead()));
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f2.svg",
                      ),
                      Text("Add Lead",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f3.svg",
                      ),
                      Text("FollowUp",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder(
                  future: GetCategoryListRepo.getLeads(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SuperResponse<List<Leads>>> snap) {
                    if (snap.hasData) {
                      List<Leads> data = snap.data!.data;
                      if (data.length == 0) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                              child: Text("No Leads Data Available",
                                  style: TextStyle(
                                      fontFamily: "Causten-bold",
                                      fontSize: 15,
                                      color: MyColors.themecolor))),
                        );
                      } else {
                        //List<Leads> data = snap.data!.data;

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index >= 0 && index < data.length) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 0.1,
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: MyColors.themecolor),
                                              child: Center(
                                                  child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                          title: Text(
                                              data[index].name == null
                                                  ? "-"
                                                  : '${data[index].name}',
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
                                                Text(
                                                    data[index].phone == null
                                                        ? "-"
                                                        : '${data[index].phone}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Causten-Regular",
                                                      fontSize: 12,
                                                    )),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  data[index].lead_date == null
                                                      ? "-"
                                                      : '${formatTimestamp(data[index].lead_date)}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Causten-Regular",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Container(
                                            height: 50,
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      contactName =
                                                          data[index].name;
                                                      contactNumber =
                                                          data[index].phone;
                                                      _contactSave();
                                                      _makePhoneCall(
                                                          data[index].phone!);
                                                    },
                                                    child: SvgPicture.asset(
                                                        "asset/Images/call.svg")),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      launchWhatsApp(
                                                          phone: data[index]
                                                              .phone
                                                              .toString(),
                                                          message: "");
                                                    },
                                                    child: Container(
                                                      //height: 10,
                                                      child: SvgPicture.asset(
                                                          "asset/Images/whatsapp.svg"),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               followupDetail(
                                            //                 lead_id: e.lead_hid,
                                            //                 leads: e,
                                            //               )));
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 30,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: MyColors
                                                            .containercolor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12))),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 55,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          child: Text(
                                                              data[index].category ==
                                                                      null
                                                                  ? '-'
                                                                  : '${data[index].category}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Causten-Regular",
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          child: Text(
                                                              "Visit Type :",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Causten-semibold",
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 3,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          child: Text(
                                                              data[index].isPatientRegistration ==
                                                                      0
                                                                  ? '-'
                                                                  : 'Visited',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Causten-Regular",
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                followupDetail(
                                                                  lead_id: data[
                                                                          index]
                                                                      .lead_hid,
                                                                  leads: data[
                                                                      index],
                                                                  indexNo: (index +
                                                                          1)
                                                                      .toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            MyColors.themecolor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12))),
                                                    child: Center(
                                                      child: Text("Followup",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Causten-Regular",
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                    } else {
                      if (snap.data?.status == 401) {
                        showAlertAndNavigateToLogin(context);
                        return Text("");
                      } else {
                        return Center(
                          child: Container(
                              height: 50,
                              child: CircularProgressIndicator(
                                color: MyColors.themecolor,
                              )),
                        );
                      }
                    }
                  }),
            ),
          ],
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
