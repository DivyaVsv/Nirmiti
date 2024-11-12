import 'dart:async';
import 'package:app_minimizer/app_minimizer.dart';
import 'package:flutter/material.dart';

import 'package:nirmiti_app/Screens/AddLeads.dart';
import 'package:nirmiti_app/Screens/AllCalls.dart';
import 'package:nirmiti_app/Screens/Followup.dart';
import 'package:nirmiti_app/Screens/Incomming.dart';
import 'package:nirmiti_app/Screens/MissedCall.dart';
import 'package:nirmiti_app/Screens/Outgoing.dart';
import 'package:nirmiti_app/Screens/Rejected.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class dashboard extends StatefulWidget {
  final tokenString;
  dashboard({this.tokenString});
  _dashboard createState() => _dashboard();
}

class _dashboard extends State<dashboard> {
  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        onBackPress();
        return false;
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: SvgPicture.asset("asset/Images/all.svg"),
                  child: Text("All calls",
                      style: TextStyle(
                        fontFamily: "Causten-Medium",
                        fontSize: 8,
                      )),
                ),
                Tab(
                  icon: SvgPicture.asset("asset/Images/income.svg"),
                  child: Text("Incomming",
                      style: TextStyle(
                        fontFamily: "Causten-Medium",
                        fontSize: 8,
                      )),
                ),
                Tab(
                  icon: SvgPicture.asset("asset/Images/out.svg"),
                  child: Text("Outgoing",
                      style: TextStyle(
                        fontFamily: "Causten-Medium",
                        fontSize: 8,
                      )),
                ),
                Tab(
                  icon: SvgPicture.asset("asset/Images/missed.svg"),
                  child: Text("Missed",
                      style: TextStyle(
                        fontFamily: "Causten-Medium",
                        fontSize: 8,
                      )),
                ),
                Tab(
                  icon: SvgPicture.asset("asset/Images/reject.svg"),
                  child: Text("Rejected",
                      style: TextStyle(
                        fontFamily: "Causten-Medium",
                        fontSize: 8,
                      )),
                ),
              ],
            ),
          ),
          floatingActionButton: InkWell(
            onTap: () {
              _makePhoneCall();
            },
            child: SvgPicture.asset(
              'asset/Images/dialer.svg',
            ),
          ),

          bottomNavigationBar: Container(
            height: 50,
            color: MyColors.boxcolor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => followup()));
                  },
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
          //  BottomNavigationBar(
          //   //  onTap: _onTabTapped,
          //   //currentIndex: _currentIndex,

          //   selectedLabelStyle: TextStyle(
          //     fontFamily: "Causten-Semibold",
          //     fontSize: 10,
          //   ),
          //   unselectedLabelStyle: TextStyle(
          //     fontFamily: "Causten-Medium",
          //     fontSize: 10,
          //   ),
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: GestureDetector(
          //           onTap: () {},
          //           child: SvgPicture.asset(
          //             "asset/Images/f1.svg",
          //           )),
          //       label: "Call History",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: GestureDetector(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => addLead()));
          //           },
          //           child: SvgPicture.asset("asset/Images/f2.svg")),
          //       label: 'Add Lead',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: GestureDetector(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => followup()));
          //           },
          //           child: SvgPicture.asset("asset/Images/f3.svg")),
          //       label: 'FollowUp',
          //     ),
          //   ],
          // ),
          body: Form(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                children: [
                  allcalls(),
                  incomingcalls(),
                  outgoingcalls(),
                  missedcalls(),
                  rejectedcalls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPress() {
    showAlertDialog(context);
    // SystemNavigator.pop();

    return Future.value(false);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style: TextStyle(
            fontFamily: "Causten-bold",
            fontSize: 12,
          )),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue",
          style: TextStyle(
            fontFamily: "Causten-bold",
            fontSize: 12,
          )),
      onPressed: () {
        FlutterAppMinimizer.minimize();
        // SystemNavigator.pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert",
          style: TextStyle(
            fontFamily: "Causten-Bold",
            fontSize: 15,
          )),
      content: Text("Would you close Nirmit App?",
          style: TextStyle(
              fontFamily: "Causten-Semibbold",
              fontSize: 12,
              color: MyColors.themecolor)),
      actions: [
        cancelButton,
        continueButton,
        // logoutButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
