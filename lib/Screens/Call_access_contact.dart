import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:permission_handler/permission_handler.dart';

class contactAccess extends StatefulWidget {
  _contactAccess createState() => _contactAccess();
}

class _contactAccess extends State<contactAccess> {
  Future<void> _getCallLogPermission(BuildContext context) async {
    // Check if the permission is granted
    if (await Permission.phone.request().isGranted) {
      // Permission is granted, navigate to another screen
      Navigator.pushNamed(context, '/callScreen');
    } else {
      // Permission is not granted, you can show an alert dialog here
      print("Call log permission not granted");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Container(
                //  height: MediaQuery.of(context).size.height / 3,
                child: Center(child: SvgPicture.asset('asset/Images/c1.svg'))),
            SizedBox(
              height: 30,
            ),
            Text(
              "Access To Your Call",
              style: TextStyle(fontFamily: "Causten-Black", fontSize: 26),
            ),
            Text(
              "History",
              style: TextStyle(fontFamily: "Causten-Black", fontSize: 26),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              //   width: MediaQuery.of(context).size.width / 1.2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Nirmiti would like to access your call history.By",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "allowing Nirmiti to access your call logs.the app can",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "analyse your data and generate reports and stastics",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "to minitor the result effectively.Call log access is",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "mandatory for Nirmiti.as its primary feature includes",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "generating call reports.",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Nirmiti does not uplod your data to any cloud",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "server without your consent.The data is stored locally",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "on your device",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Nirmiti reads call logs when running in the background",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "allowing the app to keep the logs even if it is deleted",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "also. you can receive real-time reports without",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "opening the app",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              onPressed: () {
                _getCallLogPermission(context);
                // Navigator.pushNamed(context, '/callScreen');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textColor: Colors.white,
              color: MyColors.themecolor,
              child: Text(
                "Allow Access",
                style: TextStyle(fontFamily: "Causten-Bold", fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('asset/Images/Arrows.png'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "It is secure!",
                  style: TextStyle(fontFamily: "Causten-Bold", fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Privacy Policy",
              style: TextStyle(fontFamily: "Causten-Regular", fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
