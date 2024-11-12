class User_token {
  var t;

  User_token({
    this.t,
  });
  User_token.fromJson(Map<dynamic, dynamic> json) {
    t = json['token'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['token'] = this.t;

    return data;
  }
}
