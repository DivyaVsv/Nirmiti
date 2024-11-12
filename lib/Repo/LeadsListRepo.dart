// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nirmiti_app/Model/Leads.dart';
import 'package:nirmiti_app/Utills/Internet_Connection.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/Super_Responce.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

class GetCategoryListRepo {
  static Future<SuperResponse<List<Leads>>> getLeads() async {
    BuildContext? buildContext;
    // userDetails = await SessionManager.getUser();
    // selectedCity = await SessionManager.getSelectedCity();

    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";

    print(formattedDate);
    var body = {
      //'follow_up_date': date
    };
    final token = await SessionManager.getToken();
    var isInternetConnected = await InternetUtil.isInternetConnected();
    //  if (isInternetConnected) {
    return http.get(
      Uri.parse(
          "https://nirmitiapps.in:3000/api/lead_header/lead-follow-up?follow_up_date=$formattedDate"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        if (response.statusCode == 401) {
          showAlertAndNavigateToLogin(buildContext!);
        } else {
          Fluttertoast.showToast(
              msg: "Something Wrong, Please Try again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              backgroundColor: MyColors.themecolor,
              textColor: MyColors.textcolor,
              fontSize: 12.0);
          // throw new Exception("Error while fetching data");
        }
      }

      Map<dynamic, dynamic> map = json.decode(response.body);

      Iterable data = map['data'];
      List<Leads> categoryList =
          data.map((dynamic ts) => Leads.fromJson(ts)).toList();

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
    //   throw new Exception("No Internet Connection");
    // }

    //  var categoryList = await SessionManager.getCategoryList();
    //  print(categoryList);

    // SuperResponse<List<category_model>> superResponse = SuperResponse(data: categoryList,);
    //return superResponse;
  }
}

void showAlertAndNavigateToLogin(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('Session Expired',
              style: TextStyle(
                  fontFamily: "Causten-Bold", fontSize: 20, color: Colors.red)),
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
