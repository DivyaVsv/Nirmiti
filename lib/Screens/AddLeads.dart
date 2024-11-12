import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirmiti_app/Model/Category.dart';
import 'package:nirmiti_app/Model/Leads.dart';

import 'package:nirmiti_app/Model/Leads_Status.dart';
import 'package:nirmiti_app/Repo/AddLeadsRepo.dart';
import 'package:nirmiti_app/Repo/CategoryListRepo.dart';
import 'package:nirmiti_app/Repo/LeadStatusListREspo.dart';

import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Screens/Followup.dart';
import 'package:nirmiti_app/Utills/Constant.dart';
import 'package:nirmiti_app/Utills/Session_Manager.dart';
import 'package:nirmiti_app/Utills/Super_Responce.dart';
import 'package:nirmiti_app/Utills/myColor.dart';

import 'package:intl/intl.dart';

List<String> calls = <String>[
  '1   ',
  '2   ',
  '3   ',
  '4   ',
  '5   ',
];

class addLead extends StatefulWidget {
  _addLead createState() => _addLead();
}

class _addLead extends State<addLead> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  String? dropdownvalue;
  String? dropdownvalue1;
  String? dropdownvalue2;
  var _selectedlead;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _categorycontroller = TextEditingController();
  List<String> suggestions = [];
  final suggestionList = [];
  var _name, _city, _mobile, _categoryId, _note, _comment, _noCalls;

  var myFormat = DateFormat('yyyy-MM-dd');
  var productData;
  String? search;
  String _errorText = '';
  String? namrerror,
      dateerror,
      cityerror,
      mobileeeror,
      mobileeeror1,
      cateerror,
      noteeror,
      comeeror,
      nocallerror,
      leaderror,
      leaddateerror;
  int _currentIndex = 0;

  // final List<Widget> _pages = [
  //   dashboard(),
  //   addLead(),
  //   followup(),
  // ];
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    setState(() {
      SessionManager.getUser().then((value) {
        setState(() {
          userDetails = value;
        });
      });
    });

    GetCategoryRepo.getCategory('1').then((value) {
      productData = value.data;
      for (int i = 0; i < value.data.length; i++) {
        var list = category(name: value.data[i].name);
        // var listid = category(id: value.data[i].id);
        print(list.name);
        suggestions.add(list.name.toString());
      }
    });

    super.initState();
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    // Convert UTC to IST (IST is UTC+5:30)
    var dateIst = dateUtc.add(Duration(hours: 5, minutes: 30));
    return DateFormat('HH:mm').format(dateIst);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Lead Details",
            style: TextStyle(fontFamily: "Causten-Semibold", fontSize: 18),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: MyColors.boxcolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => dashboard()));
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f1.svg",
                      ),
                      Text("Call History",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f2.svg",
                      ),
                      Text("Add Lead",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => followup()));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          bottom: BorderSide.none,
                          left: BorderSide.none)),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "asset/Images/f3.svg",
                      ),
                      Text("FollowUp",
                          style: TextStyle(
                            fontFamily: "Causten-Medium",
                            fontSize: 12,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            //  autovalidateMode: AutovalidateMode.onUserInteraction,

            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 800,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        margin: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey,
                                blurRadius: 0.1,
                              ),
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Your Name",
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: MyColors.themecolor),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onSaved: (String? value) {
                                      setState(() {
                                        namrerror = "";
                                      });
                                      _name = value!;
                                    },
                                    onChanged: (value) {
                                      // Clear error message on change
                                      if (namrerror != null) {
                                        setState(() {
                                          namrerror = "";
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 12),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily: "Causten-Regular",
                                          color: MyColors.textcolor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (namrerror != null)
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
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
                              height: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Date*",
                                            style: TextStyle(
                                                fontFamily: "Causten-Semibold",
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: MyColors.themecolor)),
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _controller1.text == ''
                                                      ? 'Select Date'
                                                      : "${_controller1.text}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Causten-Semibold",
                                                      fontSize: 12),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(2019, 1),
                                                          lastDate: DateTime(
                                                              3025, 12),
                                                          builder: (context,
                                                              picker) {
                                                            return Theme(
                                                              //TODO: change colors
                                                              data: ThemeData
                                                                      .light()
                                                                  .copyWith(
                                                                colorScheme:
                                                                    ColorScheme
                                                                        .light(
                                                                  primary: MyColors
                                                                      .themecolor,
                                                                  onPrimary:
                                                                      Colors
                                                                          .white,
                                                                  surface: Colors
                                                                      .white,
                                                                  onSurface:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                dialogBackgroundColor:
                                                                    Colors.green[
                                                                        900],
                                                              ),
                                                              child: picker!,
                                                            );
                                                          }).then((selectedDate) {
                                                        if (dateerror != null) {
                                                          setState(() {
                                                            dateerror = "";
                                                          });
                                                        }
                                                        //TODO: handle selected date
                                                        if (selectedDate !=
                                                            null) {
                                                          setState(() {
                                                            _controller1.text =
                                                                myFormat
                                                                    .format(
                                                                        selectedDate)
                                                                    .toString();
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child:
                                                        Icon(Icons.date_range)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (dateerror != null)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          //  padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            dateerror!,
                                            style: TextStyle(
                                                fontFamily: "Causten-Bold",
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        child: Text(
                                          "City*",
                                          style: TextStyle(
                                              fontFamily: "Causten-Semibold",
                                              fontSize: 10),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: MyColors.themecolor)),
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return '';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                // Clear error message on change
                                                if (cityerror != null) {
                                                  setState(() {
                                                    cityerror = "";
                                                  });
                                                }
                                              },
                                              onSaved: (String? value) {
                                                _city = value!;
                                              },
                                              keyboardType: TextInputType.text,
                                              //   controller: _controller,
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Causten-Semibold",
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    fontFamily:
                                                        "Causten-Regular",
                                                    color: MyColors.textcolor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (cityerror != null)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          //  padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            cityerror!,
                                            style: TextStyle(
                                                fontFamily: "Causten-Bold",
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "Mobile Number*",
                                            style: TextStyle(
                                                fontFamily: "Causten-Semibold",
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: MyColors.themecolor)),
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return '';
                                                }
                                                if (value.length != 10) {
                                                  return "Enter Valid Number";
                                                }

                                                return null;
                                              },
                                              maxLength: 10,
                                              onChanged: (value) {
                                                // Clear error message on change
                                                if (mobileeeror != null) {
                                                  setState(() {
                                                    mobileeeror = "";
                                                  });
                                                }
                                              },
                                              onSaved: (String? value) {
                                                _mobile = value;
                                              },

                                              // controller: _controller,
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Causten-Semibold",
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                counterText: "",
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    fontFamily:
                                                        "Causten-Regular",
                                                    color: MyColors.textcolor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (mobileeeror != null)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          margin: EdgeInsets.only(
                                            left: 10,
                                          ),
                                          // padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            mobileeeror!,
                                            style: TextStyle(
                                                fontFamily: "Causten-Bold",
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        child: Text(
                                          "Category*",
                                          style: TextStyle(
                                              fontFamily: "Causten-Semibold",
                                              fontSize: 10),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: MyColors.themecolor)),
                                          height: 50,
                                          child: Autocomplete<String>(
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              if (textEditingValue
                                                  .text.isEmpty) {
                                                setState(() {
                                                  _errorText = '';
                                                });
                                                return const Iterable<
                                                    String>.empty();
                                              }

                                              final matche = suggestions
                                                  .where((category) => category
                                                      .toLowerCase()
                                                      .contains(textEditingValue
                                                          .text
                                                          .toLowerCase()))
                                                  .toList();

                                              setState(() {
                                                if (matche.isEmpty) {
                                                  _errorText =
                                                      "No Category Found";
                                                  matche
                                                      .add("No Category Found");
                                                } else {
                                                  _errorText = '';
                                                  matche.remove(
                                                      "No Category Found");
                                                }
                                              });
                                              return matche;
                                            },

                                            onSelected: (suggestion) {
                                              if (cateerror != null) {
                                                setState(() {
                                                  cateerror = "";
                                                });
                                              }
                                              setState(() {
                                                _errorText;
                                              });
                                              _categorycontroller.text =
                                                  suggestion;
                                              GetCategoryRepo.getCategory('1')
                                                  .then((value) {
                                                for (int i = 0;
                                                    i < value.data.length;
                                                    i++) {
                                                  if (_categorycontroller
                                                          .text ==
                                                      value.data[i].name) {
                                                    var catId =
                                                        value.data[i].id;
                                                    print("11111");
                                                    print(catId);
                                                    _categoryId = catId;
                                                  }
                                                }
                                              });
                                            },

                                            fieldViewBuilder: (BuildContext
                                                    context,
                                                TextEditingController
                                                    textEditingController,
                                                FocusNode focusNode,
                                                VoidCallback onFieldSubmitted) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Causten-Semibold",
                                                      fontSize: 12),
                                                  controller:
                                                      textEditingController,
                                                  focusNode: focusNode,
                                                  decoration: InputDecoration(
                                                    border: InputBorder
                                                        .none, // Remove the underline
                                                  ),
                                                  onFieldSubmitted:
                                                      (String value) {
                                                    onFieldSubmitted();
                                                    productData =
                                                        value.toString();
                                                    print("11111");
                                                    print(productData);
                                                  },
                                                ),
                                              );
                                            },

                                            // child: TextField(
                                            //   decoration: InputDecoration(
                                            //     labelText: 'Enter a country...',
                                            //   ),
                                            // ),
                                          )),
                                      if (cateerror != null)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          //padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            cateerror!,
                                            style: TextStyle(
                                                fontFamily: "Causten-Bold",
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Note",
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: MyColors.themecolor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      // Clear error message on change
                                      if (noteeror != null) {
                                        setState(() {
                                          noteeror = "";
                                        });
                                      }
                                    },
                                    onSaved: (String? value) {
                                      _note = value!;
                                    },
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 12),
                                    keyboardType: TextInputType.text,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily: "Causten-Regular",
                                          color: MyColors.textcolor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (noteeror != null)
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                margin: EdgeInsets.only(
                                  left: 20,
                                ),
                                // padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  noteeror!,
                                  style: TextStyle(
                                      fontFamily: "Causten-Bold",
                                      color: Colors.red,
                                      fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Lead Info",
                              style: TextStyle(
                                  fontFamily: "Causten-Semibold", fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Add Comment",
                              style: TextStyle(
                                  fontFamily: "Causten-Semibold", fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        // width: MediaQuery.of(context).size.width / 1,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MyColors.themecolor),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // Clear error message on change
                                if (comeeror != null) {
                                  setState(() {
                                    comeeror = "";
                                  });
                                }
                              },
                              onSaved: (String? value) {
                                _comment = value!;
                              },
                              style: TextStyle(
                                  fontFamily: "Causten-Semibold", fontSize: 12),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontFamily: "Causten-Regular",
                                    color: MyColors.textcolor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (comeeror != null)
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          //padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            comeeror!,
                            style: TextStyle(
                                fontFamily: "Causten-Bold",
                                color: Colors.red,
                                fontSize: 12),
                          ),
                        ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        // width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Text(
                                    "No.of Calls*",
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: MyColors.themecolor)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      value: dropdownvalue,
                                      hint: new Text(
                                        'Select',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Causten-Semibold",
                                            fontSize: 12),
                                      ),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Causten-Semibold",
                                          fontSize: 10),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      onChanged: (String? value) {
                                        if (nocallerror != null) {
                                          setState(() {
                                            nocallerror = "";
                                          });
                                        }
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropdownvalue = value!;
                                          _noCalls = value;
                                        });
                                      },
                                      items: calls
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.3,
                                  child: Text(
                                    "Lead Status*",
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.1,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: MyColors.themecolor)),
                                  child: Container(
                                    // margin: const EdgeInsets.only(left: 5),
                                    child: Center(
                                      child: FutureBuilder(
                                          future: GetLeadStatusListRepo
                                              .getLeadStatus(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      SuperResponse<
                                                          List<leadsStatus>>>
                                                  snap) {
                                            if (snap.hasData) {
                                              var list = snap.data!.data;
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  itemHeight:
                                                      kMinInteractiveDimension,
                                                  hint: Center(
                                                    child: new Text(
                                                      'Select',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              "Causten-Semibold",
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  elevation: 8,
                                                  value: _selectedlead,
                                                  underline: Container(
                                                    color: Colors.white,
                                                  ),
                                                  items: list.map((Category) {
                                                    return DropdownMenuItem(
                                                      child: Center(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '${Category.id}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        1),
                                                              ),
                                                              Text(
                                                                '${Category.lead_status}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        "Causten-Semibold",
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      value: Category.id,
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    if (leaderror != null) {
                                                      setState(() {
                                                        leaderror = "";
                                                      });
                                                    }
                                                    setState(() {
                                                      _selectedlead = value;
                                                    });
                                                  });
                                            } else {
                                              return Center(
                                                child: Text(
                                                  'Select Lead Status',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "Causten-Semibold",
                                                      fontSize: 10),
                                                ),
                                              );
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.3,
                                  child: Text(
                                    "Followup Date*",
                                    style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: MyColors.themecolor)),
                                  height: 50,
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _controller.text == ''
                                                ? 'Select Date'
                                                : "${_controller.text}",
                                            style: TextStyle(
                                                fontFamily: "Causten-Semibold",
                                                fontSize: 12),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate:
                                                        DateTime(3025, 12),
                                                    builder: (context, picker) {
                                                      return Theme(
                                                        //TODO: change colors
                                                        data: ThemeData.light()
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary: MyColors
                                                                .themecolor,
                                                            onPrimary:
                                                                Colors.white,
                                                            surface:
                                                                Colors.white,
                                                            onSurface:
                                                                Colors.black,
                                                          ),
                                                          dialogBackgroundColor:
                                                              Colors.green[900],
                                                        ),
                                                        child: picker!,
                                                      );
                                                    }).then((selectedDate) {
                                                  //TODO: handle selected date
                                                  if (selectedDate != null) {
                                                    if (leaddateerror != null) {
                                                      setState(() {
                                                        leaddateerror = "";
                                                      });
                                                    }
                                                    setState(() {
                                                      _controller.text =
                                                          myFormat
                                                              .format(
                                                                  selectedDate)
                                                              .toString();
                                                    });
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.date_range,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        // width: MediaQuery.of(context).size.width / 1.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2.2,
                              height: 50,
                              onPressed: () async {
                                setState(() {
                                  onLoginButtonClick();
                                });

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => contactAccess()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              textColor: Colors.white,
                              color: MyColors.themecolor,
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(fontFamily: "Causten-bold"),
                              ),
                            ),
                            MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2.2,
                              height: 50,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              textColor: Colors.black87,
                              color: Colors.grey.shade300,
                              child: Text(
                                "CANCEL",
                                style: TextStyle(fontFamily: "Causten-bold"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onLoginButtonClick() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_noCalls == null) {
        Fluttertoast.showToast(
            msg: "Select No of Calls",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {
        _noCalls;
      }
      if (_selectedlead == null) {
        Fluttertoast.showToast(
            msg: "Select Lead Status",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {
        _selectedlead;
      }
      if (_controller.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Select Followup date",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {
        _controller.text;
      }
      if (_controller1.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Select Date",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {
        _controller1.text;
      }
      if (_categorycontroller.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Enter Category",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {
        _categorycontroller.text;
      }
      if (_mobile != 10) {
        _mobile = null;
        Fluttertoast.showToast(
            msg: "Enter Valid Mobile Number",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
      } else {}
      _formKey.currentState!.save();
      print('form is valid');

      var name = _name;
      var lead_date = _controller1.text;
      var city = _city;
      var phone = _mobile;
      var note = _note;
      var catId = _categoryId;
      var comments = _comment;
      var callingtime = "-";
      var callsNo = _noCalls;
      var leadStatusId = _selectedlead;
      var followDate = _controller.text;
      List orderData = [];
      var orderItems = leadFooterDetails(
          comments: comments,
          calling_time: callingtime,
          no_of_calls: callsNo,
          lead_status_id: leadStatusId,
          follow_up_date: followDate);
      orderData.add(orderItems);

      var response = await AddLeads_repo.AddLeads(
          name, lead_date, city, phone, note, catId, orderData);

      print(response);
      if (response.status == 401) {
        //TODO show error

        // ignore: unnecessary_null_comparison
        // if (response.data == null) {
        Fluttertoast.showToast(
            msg: "Your Session is expired.Please Login again.. ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => dashboard()));
        // } else {}
      }
      if (response.status == 200) {
        Fluttertoast.showToast(
            msg: 'Lead Added Successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: Colors.amber[200],
            textColor: MyColors.themecolor,
            fontSize: 12.0);
        //_formKey.currentState!.reset();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => followup()));
        setState(() {
          _controller.clear();
          _controller1.clear();
          _categorycontroller.clear();
        });
      }
      if (response.status == 422) {
        //TODO show error

        // ignore: unnecessary_null_comparison
        // if (response.data == null) {
        Fluttertoast.showToast(
            msg: response.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
        // } else {}
      }
    } else {
      if (namrerror != null) {
        namrerror = "";
      } else {
        namrerror = "Enter Name";
      }
      if (cityerror != null) {
        cityerror = "";
      } else {
        cityerror = "Enter City";
      }
      if (mobileeeror != null) {
        mobileeeror = "";
      } else {
        mobileeeror = "Enter Mobile";
      }

      if (noteeror != null) {
        namrerror = "";
      } else {
        noteeror = "Enter Note";
      }
      if (comeeror != null) {
        comeeror = "";
      } else {
        comeeror = "Enter Comment";
      }
      if (cateerror != null) {
        cateerror = "";
      } else {
        cateerror = "Enter Category";
      }
      // if (mobileeeror!.length != 10) {
      //   mobileeeror = "Enter Valid Number";
      // }
      dateerror = "Enter Date";
      nocallerror = "Select No Of Calls";
      leaddateerror = "Enter Date";
      leaderror = "Select Lead  Status";
      Fluttertoast.showToast(
          msg: "Please Enter Details",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.amber[200],
          textColor: MyColors.themecolor,
          fontSize: 12.0);
    }
  }
}
