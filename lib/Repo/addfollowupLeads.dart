// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nirmiti_app/Model/Leads.dart';
import 'package:nirmiti_app/Utills/Internet_Connection.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/myColor.dart';
import 'package:nirmiti_app/Utills/response.dart';

class UpdateFollowUpDetailRepo {
  static Future<superresponse<Leads>> updateFollowupLeads(
      var lead_fid, var category_id, List details) async {
    //FirebaseApp.initializeApp();
    var isInternetConnected = await InternetUtil.isInternetConnected();
    final token = await SessionManager.getToken();

    var body = {"category_id": category_id, "leadFooterDetails": details};
    //  if (isInternetConnected) {
    return http
        .put(
            Uri.parse(
                "https://nirmitiapps.in:3000/api/lead_header/lead-follow-up/$lead_fid"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body))
        .then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 404 ||
          json == null) {
        Map<dynamic, dynamic> map = json.decode(response.body);
        final data = map['message'];
        Fluttertoast.showToast(
            msg: data,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber.shade200,
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      }
      print(response.body);
      Map<dynamic, dynamic> map = json.decode(response.body);
      final data = map['message'];

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
