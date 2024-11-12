class superresponse<t> {
  var status = null;
  var message = null;
  var title = null;

  superresponse({this.status, this.message, this.title});

  factory superresponse.fromJson(Map<dynamic, dynamic> json) {
    return superresponse(
      status: json['status'],
      message: json['msg'],
      title: json['token'],
    );
  }
}
