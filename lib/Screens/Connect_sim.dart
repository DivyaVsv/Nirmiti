import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:nirmiti_app/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';

// ignore: must_be_immutable
class connectSIM extends StatefulWidget {
  final tokenString;
  User_Registration? user;
  final timer;

  connectSIM({this.tokenString, this.user, this.timer});
  _connectSIM createState() => _connectSIM(this.tokenString);
}

class _connectSIM extends State<connectSIM> {
  _connectSIM(this.token);
  // final Telephony telephony = Telephony.instance;
  late SharedPreferences sharedPreferences;
  String token;
  String? carrierName;
  String? countryCode;
  String? displayName;
  String? mcc;
  String? mnc;
  int? slotIndex;
  String _mobileNo = "";
  final _formKey = GlobalKey<FormState>();
  String? namrerror;
  String? _userInputNumber;
  String? _simNumber1, _simNumber2;
  SimInfo simInfo = SimInfo([]);

  @override
  void initState() {
    super.initState();
    //permission1();
    SimNumber.listenPhonePermission((isPermissionGranted) {
      print("isPermissionGranted : " + isPermissionGranted.toString());
      if (isPermissionGranted) {
        initPlatformState();
      } else {}
    });
    // initPlatformState();
  }

  // void getSimInfo() async {
  //   try {
  //     simData = await SimDataPlugin.getSimData();
  //     print(simData!.cards);
  //   } catch (e) {
  //     print("Failed to get SIM data: $e");
  //   }
  // }

  Future<void> initPlatformState() async {
    try {
      simInfo = await SimNumber.getSimData();
      setState(() {
        var sim1 = simInfo.cards[0];
        var sim2 = simInfo.cards[1];

        if (simInfo.cards.isNotEmpty) {
          setState(() {
            _simNumber1 = sim1.phoneNumber ?? "";
            _simNumber2 = sim2.phoneNumber ?? "";
            carrierName = sim1.carrierName ?? sim2.carrierName;

            if (_simNumber1!.length == 12) {
              _simNumber1 = _simNumber1!.substring(2);
            } else {
              _simNumber1;
            }

            if (_simNumber2!.length == 12) {
              _simNumber2 = _simNumber2!.substring(2);
            } else {
              _simNumber2;
            }
          });
        }
      });
    } catch (e) {
      print("error");
    }
    //if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connect Sim",
          style: TextStyle(
            fontFamily: "Causten-Regular",
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset("asset/Images/Arrows.png"),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    "Due to latest google policy & Android version we",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontFamily: "Causten-Regular",
                                        fontSize: 12,
                                        color: Colors.grey)),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    "have to connect required information by verifying",
                                    style: TextStyle(
                                        fontFamily: "Causten-Regular",
                                        fontSize: 12,
                                        color: Colors.grey)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("your phone number",
                                    style: TextStyle(
                                        fontFamily: "Causten-Regular",
                                        fontSize: 12,
                                        color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("asset/Images/sim.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        carrierName == null ? "" : '${carrierName}',
                        style:
                            TextStyle(fontFamily: "Causten-Bold", fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Text(
                    "Enter Your Number",
                    style: TextStyle(fontFamily: "Causten-Bold", fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MyColors.themecolor),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return '';
                          }
                          if (value.length > 10) {
                            return "Enter Valid Number";
                          }

                          return null;
                        },
                        onSaved: (String? value) {
                          _mobileNo = value!;
                        },
                        onChanged: (value) {
                          setState(() {
                            _userInputNumber = value;
                          });
                          // Clear error message on change
                          if (namrerror != null) {
                            setState(() {
                              namrerror = "";
                            });
                          }
                        },
                        style:
                            TextStyle(fontFamily: "Causten-bold", fontSize: 15),
                        decoration: InputDecoration(
                          // hintText: '00000 00000',
                          hintStyle: TextStyle(
                              fontFamily: "Causten-Bold",
                              color: MyColors.textcolor),
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (namrerror != null)
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    // padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      namrerror!,
                      style: TextStyle(
                          fontFamily: "Causten-Bold",
                          color: Colors.red,
                          fontSize: 12),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 1.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    // if (_userInputNumber == _simNumber1 ||
                    //     _userInputNumber == _simNumber2) {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      {
                        if (_mobileNo == widget.user?.phone) {
                          SessionManager.saveUserObject(widget.user!);
                          SessionManager.saveToken(widget.tokenString);
                          // SessionManager()
                          //     .saveTokenTimer(widget.tokenString, 60);
                          startTokenTimer(context);
                          Fluttertoast.showToast(
                              msg: "Login Succesfull",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.amber[200],
                              textColor: MyColors.themecolor,
                              fontSize: 12.0);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dashboard()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Mobile Number Not Match",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.amber[200],
                              textColor: MyColors.themecolor,
                              fontSize: 12.0);
                        }
                      }
                    } else {
                      namrerror = 'Enter Mobile No.';
                    }
                    // } else {
                    //   Fluttertoast.showToast(
                    //       msg: "Mobile Number do Not Match",
                    //       toastLength: Toast.LENGTH_LONG,
                    //       gravity: ToastGravity.CENTER,
                    //       timeInSecForIosWeb: 10,
                    //       backgroundColor: Colors.amber[200],
                    //       textColor: MyColors.themecolor,
                    //       fontSize: 12.0);
                    // }
                  },
                  textColor: Colors.white,
                  color: MyColors.themecolor,
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(fontFamily: "Causten-Bold", fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTokenTimer(BuildContext context) {
    Timer(Duration(seconds: widget.timer), () {
      showAlertAndNavigateToLogin(context);
      // SessionManager.updateLastActiveTime();
    });
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
}
