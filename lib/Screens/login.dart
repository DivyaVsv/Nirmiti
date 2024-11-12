import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirmiti_app/Model/User.dart';
import 'package:nirmiti_app/Repo/Login.dart';
import 'package:nirmiti_app/Screens/Connect_sim.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

class Login extends StatefulWidget {
  _login createState() => _login();
}

class _login extends State<Login> {
  late final User_Registration user;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  String _mobileNo = "";
  String _password = "";
  var tokenString;
  String? namrerror, passerror;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      "E-mail ID",
                      style:
                          TextStyle(fontFamily: "Causten-Bold", fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          // if (value!.isEmpty) {
                          //   return '';
                          // }

                          return null;
                        },
                        onSaved: (String? value) {
                          _mobileNo = value!;
                        },
                        style: TextStyle(
                            fontFamily: "Causten-Semibold", fontSize: 16),
                        decoration: InputDecoration(
                          //hintText: 'xyz@gmail.com',
                          hintStyle: TextStyle(
                              fontFamily: "Causten-Regular",
                              color: MyColors.textcolor),
                          border: InputBorder.none,
                          errorStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) {
                          // Clear error message on change
                          if (namrerror != null) {
                            setState(() {
                              namrerror = "";
                            });
                          }
                        },
                      ),
                    )),
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
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      "Password",
                      style:
                          TextStyle(fontFamily: "Causten-Bold", fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            // if (value!.isEmpty) {
                            //   return '';
                            // }
                            return null;
                          },
                          onSaved: (String? value) {
                            _password = value!;
                          },
                          onChanged: (value) {
                            // Clear error message on change
                            if (passerror != null) {
                              setState(() {
                                passerror = "";
                              });
                            }
                          },
                          // controller: _userPasswordController,
                          obscureText: _passwordVisible,
                          style: TextStyle(
                              fontFamily: "Causten-Semibold", fontSize: 16),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            // hintText: '******',
                            hintStyle: TextStyle(
                                fontFamily: "Causten-Regular",
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
                  if (passerror != null)
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      //  padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        passerror!,
                        style: TextStyle(
                            fontFamily: "Causten-Bold",
                            color: Colors.red,
                            fontSize: 12),
                      ),
                    ),
                  SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width / 1.5,
                    height: 40,
                    onPressed: () {
                      onLoginButtonClick();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => connectSIM()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    textColor: Colors.white,
                    color: MyColors.themecolor,
                    child: Text(
                      "SUBMIT",
                      style:
                          TextStyle(fontFamily: "Causten-Bold", fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginButtonClick() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('form is valid');
      if (_password.isEmpty) {
        passerror = "Enter Password";
      } else {
        _password;
      }
      if (_mobileNo.isEmpty) {
        namrerror = "Enter Email";
      } else {
        _mobileNo;
      }

      // _mobileNo = 'tanim@gmail.com';
      // _password = '123456';

      //var isInternetConnected = await InternetUtil.isInternetConnected();

      // ProgressDialog.showProgressDialog(context);
      if (_mobileNo.isEmpty || _password.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Email & Password...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      } else {
        var response = await Login_repo.Login(_mobileNo, _password);
        print("**********");
        tokenString = response.title;

        if (response.status == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => connectSIM(
                        tokenString: tokenString,
                        user: response.data,
                        timer: response.expiredTime,
                      )));
        } else {
          Fluttertoast.showToast(
              msg: "Mobile & Password Wrong...",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              backgroundColor: MyColors.themecolor,
              textColor: MyColors.textcolor,
              fontSize: 12.0);
          Navigator.pop(context);
        }

        if (response.status == 404) {
          //TODO show error

          // ignore: unnecessary_null_comparison
          if (response.data == null) {
            Fluttertoast.showToast(
                msg: "You are not register User.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 10,
                backgroundColor: MyColors.themecolor,
                textColor: MyColors.textcolor,
                fontSize: 12.0);
          } else {}
        }
      }
    } else {
      // namrerror = 'Enter Email';
      // passerror = "Enter Password";
    }
  }

  Future<bool> onBackPress() {
    SystemNavigator.pop();
    return Future.value(false);
  }
}
