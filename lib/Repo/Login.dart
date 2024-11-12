import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nirmiti_app/Model/User.dart';
import 'package:nirmiti_app/Utills/Internet_Connection.dart';
import 'package:nirmiti_app/Utills/Super_Responce.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

class Login_repo {
  static Future<SuperResponse<User_Registration>> Login(
      String email, String password) async {
    var body = {'email_id': email, 'password': password};
    var isInternetConnected = await InternetUtil.isInternetConnected();
    // if (isInternetConnected) {
    return http
        .post(Uri.parse("https://nirmitiapps.in:3000/api/super_admin/login"),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
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

        // throw new Exception("Error while fetching data");
      } else {}

      print(response.body);
      Map<dynamic, dynamic> map = json.decode(response.body);

      //SessionManager.saveToken(token);
      final data = map['data'];

      // if (data != null && data != "") {
      return SuperResponse.fromJson(map, User_Registration.fromJson(data));
      // } else {
      //  var t = null;
      //   return SuperResponse.fromJson(map, User_Registration.fromJson(data));
      //}
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
    //   throw new Exception("No Internet Connection");
    // }
  }
}
