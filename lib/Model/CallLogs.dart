class callLog {
  var mobile_number;
  var customer_name;
  var calling_type;
  var call_duration;

  callLog({
    this.mobile_number,
    this.customer_name,
    this.calling_type,
    this.call_duration,
  });
  callLog.fromJson(Map<dynamic, dynamic> json) {
    mobile_number = json['mobile_number'];
    customer_name = json['customer_name'];
    calling_type = ['calling_type'];
    call_duration = ['call_duration'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['mobile_number'] = this.mobile_number;
    data['customer_name'] = this.customer_name;
    data['calling_type'] = this.calling_type;
    data['call_duration'] = this.call_duration;

    return data;
  }
}
