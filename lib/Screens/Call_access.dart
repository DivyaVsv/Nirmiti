import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:permission_handler/permission_handler.dart';

class callAccess extends StatefulWidget {
  _callAccess createState() => _callAccess();
}

class _callAccess extends State<callAccess> {
  Future<void> _getContactsPermission(BuildContext context) async {
    // Request contacts permission
    PermissionStatus status = await Permission.contacts.request();

    // Check if the permission is granted
    if (status.isGranted) {
      // Permission is granted, navigate to another screen
      Navigator.pushNamed(context, '/login');
    } else {
      // Permission is not granted, show an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Contacts permission is required to proceed.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
              height: 80,
            ),
            Container(
                //height: MediaQuery.of(context).size.height / 2.5,
                child: Center(child: SvgPicture.asset('asset/Images/c2.svg'))),
            SizedBox(
              height: 30,
            ),
            Text(
              "Access To Your Contact",
              style: TextStyle(fontFamily: "Causten-Black", fontSize: 26),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              // width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Nirmiti needs to access your contacts to display",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "respective calls and analyse contact call data.",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Granting contact permission is mandatory as it",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "supports core feature of Nirmiti",
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
                        "We assure you that your contacts will not be ",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "uploaded on cloud server.We store the data within",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "your device",
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
                        "If the contacts is more than 3000.we run the process ",
                        style: TextStyle(
                            fontFamily: "Causten-Regular", fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "in background to avoid wait time.",
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
                //  Navigator.pushNamed(context, '/login');
                _getContactsPermission(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textColor: Colors.white,
              color: MyColors.themecolor,
              child: Text(
                "Let's Do it",
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
                  "We are safe!",
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
