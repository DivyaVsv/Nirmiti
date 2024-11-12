class Leads {
  int? lead_fid;
  String? name;
  int? lead_hid;
  String? comments;
  var follow_up_date;
  var calling_time;
  var no_of_calls;
  String? city;
  var lead_status_id;
  var isFollowUp;
  int? customer_id = null;
  String? phone;
  String? note;
  String? lead_date;
  String? category;
  int? category_id = null;
  var employee_name;
  var lead_status;
  var isPatientRegistration;
  List<leadFooterDetails>? details;

  Leads(
      {this.lead_fid,
      this.name,
      this.lead_hid,
      this.follow_up_date,
      this.calling_time,
      this.city,
      this.phone,
      this.isFollowUp,
      this.customer_id,
      this.note,
      this.lead_date,
      this.category,
      this.category_id,
      this.employee_name,
      this.isPatientRegistration,
      this.details});
  Leads.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    lead_hid = json['lead_hid'];
    city = json['city'];
    phone = json['mobile_number'];
    isFollowUp = json['isFollowUp'];
    customer_id = json['customer_id'];
    note = json['note'];
    lead_date = json['lead_date'];
    category = json['category_name'];
    category_id = json['category_id'];
    employee_name = json['employee_name'];
    isPatientRegistration = json['isPatientRegistration'];
    details = json['leadFooterDetails'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['name'] = this.name;
    data['lead_hid'] = this.lead_hid;
    data['city'] = this.city;
    data['mobile_number'] = this.phone;
    data['isFollowUp'] = this.isFollowUp;
    data['pcustomer_id'] = this.customer_id;
    data['note'] = this.note;
    data['lead_date'] = this.lead_date;
    data['category_name'] = this.category;
    data['category_id'] = this.category_id;
    data['employee_name'] = this.employee_name;
    data['isPatientRegistration'] = this.isPatientRegistration;
    data['leadFooterDetails'] = this.details;

    return data;
  }
}

class leadFooterDetails {
  var lead_fid;
  var comments;
  var calling_time;
  var no_of_calls;
  var lead_status_id;
  var lead_status;
  var follow_up_date;

  leadFooterDetails(
      {this.lead_fid,
      this.comments,
      this.calling_time,
      this.no_of_calls,
      this.lead_status_id,
      this.lead_status,
      this.follow_up_date});
  leadFooterDetails.fromJson(Map<dynamic, dynamic> json) {
    lead_fid = json['lead_fid'];
    comments = json['comments'];
    calling_time = json['calling_time'];
    no_of_calls = json['no_of_calls'];
    lead_status_id = json['lead_status_id'];
    lead_status = json['lead_status'];
    follow_up_date = json['follow_up_date'];
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['lead_fid'] = this.lead_fid;
    data['comments'] = this.comments;
    data['calling_time'] = this.calling_time;
    data['no_of_calls'] = this.no_of_calls;
    data['lead_status_id'] = this.lead_status_id;
    data['lead_status'] = this.lead_status;
    data['follow_up_date'] = this.follow_up_date;

    return data;
  }
}
