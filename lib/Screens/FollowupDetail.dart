import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirmiti_app/Model/Category.dart';
import 'package:nirmiti_app/Model/Leads.dart';
import 'package:nirmiti_app/Model/Leads_Status.dart';
import 'package:nirmiti_app/Repo/CategoryListRepo.dart';
import 'package:nirmiti_app/Repo/LeadStatusListREspo.dart';
import 'package:nirmiti_app/Repo/addfollowupLeads.dart';
import 'package:nirmiti_app/Repo/getLeadDetail.dart';
import 'package:nirmiti_app/Screens/AddLeads.dart';
import 'package:nirmiti_app/Screens/Dashboard.dart';
import 'package:nirmiti_app/Screens/Followup.dart';
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

// ignore: must_be_immutable
class followupDetail extends StatefulWidget {
  var lead_id;
  var indexNo;
  Leads? leads;
  followupDetail({this.lead_id, this.leads, this.indexNo});
  _followupDetail createState() => _followupDetail();
}

class _followupDetail extends State<followupDetail> {
  final _formKey = GlobalKey<FormState>();
  var comments;
  var CallsNo;
  int leadsStatusId = 1;
  var leadFid;
  var followUpdate;
  var category_id;
  TextEditingController _controller = TextEditingController();
  TextEditingController _categorycontroller = TextEditingController();
  // TextEditingController _commentcontroller = TextEditingController();
  String? dropdownValue;
  var productData;
  List<String> suggestions = [];
  final suggestionList = [];

  // List of items in our dropdown menu
  var _selectedlead;
  var myFormat = DateFormat('yyyy-MM-d');
  String _errorText = '';

  @override
  void initState() {
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

  String formatTimestamp(var timestamp) {
    if (timestamp == null) return 'Unknown';
    // Convert to DateTime in UTC
    var dateUtc = DateTime.parse(timestamp);
    // Convert UTC to IST (IST is UTC+5:30)

    return DateFormat('yyyy-MM-dd').format(dateUtc);
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
          height: 55,
          decoration: BoxDecoration(
            color: MyColors.containercolor,
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Column(
                      children: [
                        Container(
                            height: 25,
                            child: SvgPicture.asset("asset/Images/f1.svg")),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Call History",
                            style: TextStyle(
                              fontFamily: "Causten-Medium",
                              fontSize: 10,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => dashboard()));
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Container(
                            height: 25,
                            child: SvgPicture.asset("asset/Images/f2.svg")),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Add lead",
                            style: TextStyle(
                              fontFamily: "Causten-Medium",
                              fontSize: 10,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addLead()));
                    },
                  ),
                  InkWell(
                    child: Column(
                      children: [
                        Container(
                            height: 25,
                            child: SvgPicture.asset("asset/Images/f3.svg")),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Followup",
                            style: TextStyle(
                              fontFamily: "Causten-Medium",
                              fontSize: 10,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => followup()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.all(15),
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
                        ListTile(
                          leading: Column(
                            children: [
                              Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: MyColors.themecolor),
                                  child: Center(
                                      child: Text(
                                    "${widget.indexNo}",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                            ],
                          ),
                          title: Text(
                              widget.leads?.name == null
                                  ? '-'
                                  : "${widget.leads?.name}",
                              style: TextStyle(
                                fontFamily: "Causten-SemiBold",
                                fontSize: 18,
                              )),
                          subtitle: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.8,
                                      child: Text(
                                          widget.leads?.lead_date == null
                                              ? '-'
                                              : '${formatTimestamp(widget.leads?.lead_date)}',
                                          style: TextStyle(
                                            fontFamily: "Causten-SemiBold",
                                            fontSize: 12,
                                          )),
                                    ),
                                    Text(
                                      widget.leads?.city == null
                                          ? '-'
                                          : "${widget.leads?.city}",
                                      style: TextStyle(
                                        fontFamily: "Causten-Semibold",
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Text(
                                          widget.leads?.phone == null
                                              ? '-'
                                              : "${widget.leads?.phone}",
                                          style: TextStyle(
                                            fontFamily: "Causten-SemiBold",
                                            fontSize: 12,
                                          )),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 50,
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: MyColors.themecolor)),
                                        child: Autocomplete<String>(
                                          initialValue: TextEditingValue(
                                              text:
                                                  "${widget.leads?.category}"),
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text.isEmpty) {
                                              setState(() {
                                                widget.leads?.category;
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
                                                matche.add("No Category Found");
                                              } else {
                                                _errorText = '';
                                                matche.remove(
                                                    "No Category Found");
                                              }
                                            });
                                            return matche;
                                          },
                                          onSelected: (suggestion) {
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
                                                if (_categorycontroller.text ==
                                                    value.data[i].name) {
                                                  var catId = value.data[i].id;
                                                  print("11111");
                                                  print(catId);
                                                  category_id = catId;
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
                                            return Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
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
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 11.5,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  color: MyColors.boxcolor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, bottom: 5, top: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Note",
                                            style: TextStyle(
                                                fontFamily: "Causten-Medium",
                                                fontSize: 12)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            widget.leads?.note == null
                                                ? '-'
                                                : "${widget.leads?.note}",
                                            style: TextStyle(
                                                fontFamily: "Causten-Regular",
                                                fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: GetLeadsDetailRepo.getLeadsDetail(widget.lead_id),
                      builder: (BuildContext context,
                          AsyncSnapshot<SuperResponse<List<leadFooterDetails>>>
                              snap) {
                        if (snap.hasData) {
                          var list = snap.data?.data;

                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            "Lead Info",
                                            style: TextStyle(
                                                fontFamily: "Causten-Semibold",
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          decoration: BoxDecoration(
                                              color: MyColors.boxcolor,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, bottom: 5, top: 5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            3,
                                                        child: Text("Comments",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Causten-Medium",
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            7.3,
                                                        child: Text(
                                                            "No.of Calls",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Causten-Medium",
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            6,
                                                        child: Text(
                                                            "Lead Status",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Causten-Medium",
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1 /
                                                            5,
                                                        child: Text(
                                                            "Follow up Date",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Causten-Medium",
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      itemCount: list?.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var item = list![index];
                                                        leadFid = list[0]
                                                                    .lead_fid ==
                                                                null
                                                            ? []
                                                            : list[0].lead_fid;

                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.1,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    3,
                                                                child: Text(
                                                                    item.comments ==
                                                                            null
                                                                        ? '-'
                                                                        : "${item.comments}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Causten-Medium",
                                                                      fontSize:
                                                                          10,
                                                                    )),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    7.3,
                                                                child: Center(
                                                                  child: Text(
                                                                      item.no_of_calls ==
                                                                              null
                                                                          ? '-'
                                                                          : "${item.no_of_calls}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            "Causten-Medium",
                                                                        fontSize:
                                                                            10,
                                                                      )),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    6,
                                                                child: Text(
                                                                    item.lead_status ==
                                                                            null
                                                                        ? '-'
                                                                        : "${item.lead_status}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Causten-Medium",
                                                                      fontSize:
                                                                          10,
                                                                    )),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1 /
                                                                    6,
                                                                child: Text(
                                                                    item.follow_up_date ==
                                                                            null
                                                                        ? '-'
                                                                        : '${formatTimestamp(item.follow_up_date)}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "Causten-Medium",
                                                                      fontSize:
                                                                          10,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        "Add Comment",
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: MyColors.themecolor),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        onSaved: (String? value) {
                                          comments = value!;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Comment';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            fontFamily: "Causten-Semibold",
                                            fontSize: 12),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              fontFamily: "Causten-Regular",
                                              color: MyColors.textcolor),
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Text(
                                              "No.of Calls*",
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Causten-Semibold",
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
                                                3.8,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color:
                                                        MyColors.themecolor)),
                                            child: Center(
                                              child: DropdownButton<String>(
                                                value: dropdownValue,
                                                hint: new Text(
                                                  'Select',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "Causten-Semibold",
                                                      fontSize: 12),
                                                ),
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                elevation: 16,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        "Causten-Semibold",
                                                    fontSize: 10),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.white,
                                                ),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    dropdownValue = value!;
                                                    CallsNo = value;
                                                  });
                                                },
                                                items: calls.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            child: Text(
                                              "Lead Status*",
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Causten-Semibold",
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
                                                3.2,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color:
                                                        MyColors.themecolor)),
                                            child: Center(
                                              child: FutureBuilder(
                                                  future: GetLeadStatusListRepo
                                                      .getLeadStatus(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              SuperResponse<
                                                                  List<
                                                                      leadsStatus>>>
                                                          snap) {
                                                    if (snap.hasData) {
                                                      var list =
                                                          snap.data!.data;
                                                      return DropdownButton(
                                                          isExpanded: true,
                                                          hint: Center(
                                                            child: new Text(
                                                              'Select',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Causten-Semibold",
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                          value: _selectedlead,
                                                          underline: Container(
                                                            color: Colors.white,
                                                          ),
                                                          items: list
                                                              .map((Category) {
                                                            return DropdownMenuItem(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3),
                                                                child: Center(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        '${Category.id}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 1),
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
                                                              value:
                                                                  Category.id,
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _selectedlead =
                                                                  value;
                                                            });
                                                          });
                                                    } else {
                                                      return Text(
                                                        'Select',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                "Causten-Semibold",
                                                            fontSize: 12),
                                                      );
                                                    }
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            child: Text(
                                              "Followup Date*",
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Causten-Semibold",
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
                                                3.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color:
                                                        MyColors.themecolor)),
                                            height: 50,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      _controller.text == ""
                                                          ? "Select Date"
                                                          : '${_controller.text}',
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
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      2019, 1),
                                                              lastDate:
                                                                  DateTime(
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
                                                                      primary:
                                                                          MyColors
                                                                              .themecolor,
                                                                      onPrimary:
                                                                          Colors
                                                                              .white,
                                                                      surface:
                                                                          Colors
                                                                              .white,
                                                                      onSurface:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    dialogBackgroundColor:
                                                                        Colors.green[
                                                                            900],
                                                                  ),
                                                                  child:
                                                                      picker!,
                                                                );
                                                              }).then((selectedDate) {
                                                            if (selectedDate !=
                                                                null) {
                                                              setState(() {
                                                                _controller
                                                                        .text =
                                                                    myFormat
                                                                        .format(
                                                                            selectedDate)
                                                                        .toString();
                                                                followUpdate = myFormat
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        onPressed: () {
                                          setState(() {
                                            onButtonClick();
                                          });

                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => contactAccess()));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        textColor: Colors.white,
                                        color: MyColors.themecolor,
                                        child: Text(
                                          "SUBMIT",
                                          style: TextStyle(
                                              fontFamily: "Causten-Bold"),
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        textColor: Colors.black87,
                                        color: Colors.grey.shade300,
                                        child: Text(
                                          "CANCEL",
                                          style: TextStyle(
                                              fontFamily: "Causten-Bold"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.9,
                            child: Center(
                                child: Text("No Data Found",
                                    style: TextStyle(
                                        fontFamily: "Causten-Bold",
                                        fontSize: 15,
                                        color: MyColors.themecolor))),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  void onButtonClick() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('form is valid');
      print(leadFid);
      print(widget.leads?.lead_hid);
      var no;
      if (CallsNo == null) {
        Fluttertoast.showToast(
            msg: "Select No of Calls",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      } else {
        no = int.parse(CallsNo);
      }
      if (_selectedlead == null) {
        Fluttertoast.showToast(
            msg: "Select Lead Status",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      } else {
        _selectedlead;
      }
      if (followUpdate == null) {
        Fluttertoast.showToast(
            msg: "Select Followup Date",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      } else {
        followUpdate;
      }
      if (category_id == null) {
        category_id = widget.leads?.category_id;
      } else {
        category_id;
      }

      var calling_time = '-';

      comments = comments;
      followUpdate = _controller.text;
      List orderData = [];
      var orderItems = leadFooterDetails(
          lead_fid: leadFid,
          comments: comments,
          calling_time: calling_time,
          no_of_calls: no,
          lead_status_id: _selectedlead,
          follow_up_date: followUpdate);
      orderData.add(orderItems);
      var response = await UpdateFollowUpDetailRepo.updateFollowupLeads(
          widget.leads?.lead_hid, category_id, orderData);

      if (response.status == 200) {
        Fluttertoast.showToast(
            msg: "Detail Update Succesfull",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
        _formKey.currentState?.reset();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => followup()));
        _controller.clear();
        setState(() {
          _selectedlead;
        });
      } else if (response.status == 402) {
        Fluttertoast.showToast(
            msg: "Wrong Data...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            backgroundColor: MyColors.themecolor,
            textColor: MyColors.textcolor,
            fontSize: 12.0);
      } else {}
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter All Fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: MyColors.themecolor,
          textColor: MyColors.textcolor,
          fontSize: 12.0);
    }
  }
}
