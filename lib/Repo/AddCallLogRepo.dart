import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nirmiti_app/Model/CallLogs.dart';
import 'package:nirmiti_app/Utills/Internet_Connection.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:nirmiti_app/Utills/response.dart';

class AddCallLog_repo {
  static Future<superresponse<callLog>> AddCalllog(
      var phone, var name, var type, var duration) async {
    var isInternetConnected = await InternetUtil.isInternetConnected();
    final token = await SessionManager.getToken();
    var body = {
      "mobile_number": phone,
      "customer_name": name,
      "calling_type": type,
      "call_duration": duration,
    };
    // if (isInternetConnected) {
    return http
        .post(Uri.parse("https://nirmitiapps.in:3000/api/call-log"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body))
        .then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          // ignore: unnecessary_null_comparison
          json == null) {
        Map<dynamic, dynamic> map = json.decode(response.body);
        final data = map['message'];

        Fluttertoast.showToast(
            msg: data,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);

        //  throw new Exception("Error while fetching data");
      }

      Map<dynamic, dynamic> map = json.decode(response.body);
      final data = map['message'];
      print("********");
      print(response.body);

      return superresponse.fromJson(map);
    });
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "No Internet Connection",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 10,
    //       backgroundColor: MyColors.themecolor,
    //       textColor: MyColors.textcolor,
    //       fontSize: 12.0);
    //   throw new Exception("Error while fetching data");
    // }
  }
}
