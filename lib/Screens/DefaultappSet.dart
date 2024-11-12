import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirmiti_app/Screens/Call_access_contact.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

class defaultAPP extends StatefulWidget {
  _defaultAPP createState() => _defaultAPP();
}

class _defaultAPP extends State<defaultAPP> {
  static const platform = MethodChannel('com.example/call');

  Future<void> promptToSetDefaultDialer() async {
    try {
      await platform.invokeMethod('promptToSetDefaultDialer');
    } on PlatformException catch (e) {
      print("Failed to prompt default dialer: '${e.message}'.");
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
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(child: Image.asset("asset/Images/Frame.png"))),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  "Set Default Phone App",
                  style: TextStyle(fontFamily: "Causten-Black", fontSize: 25),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "By permitting, you accept to intiate calls through Nirmiti",
            style: TextStyle(fontFamily: "Causten-Regular", fontSize: 12),
          ),
          Text(
            "App dialer when using this application",
            style: TextStyle(fontFamily: "Causten-Regular", fontSize: 12),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              // setDefaultDialer();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => contactAccess()));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            textColor: Colors.white,
            color: MyColors.themecolor,
            child: Text(
              "Yes ! I Agree",
              style: TextStyle(fontFamily: "Causten-Regular"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Privacy Policy",
            style: TextStyle(fontFamily: "Causten-Regular", fontSize: 10),
          ),
        ],
      ),
    );
  }
}
