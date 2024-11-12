// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nirmiti_app/Model/Category.dart';
import 'package:nirmiti_app/Utills/Internet_Connection.dart';

import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/Super_Responce.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

class GetCategoryRepo {
  static Future<SuperResponse<List<category>>> getCategory(String id) async {
    var body = {'customer_id': id};
    final token = await SessionManager.getToken();
    var isInternetConnected = await InternetUtil.isInternetConnected();
    // if (isInternetConnected) {
    return http.get(
      Uri.parse("https://nirmitiapps.in:3000/api/category/wma?$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        Fluttertoast.showToast(
            msg: "Something Wrong.Please Try again..",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      }

      Map<dynamic, dynamic> map = json.decode(response.body);

      Iterable data = map['data'];
      List<category> categoryList =
          data.map((dynamic ts) => category.fromJson(ts)).toList();

      var superResponse = SuperResponse.fromJson(map, categoryList);
      return superResponse;
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
