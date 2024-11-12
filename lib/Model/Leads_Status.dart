class leadsStatus {
  String? lead_status = null;
  int? id = null;
  var cts = null;
  var status;

  leadsStatus({
    this.id,
    this.lead_status,
    this.cts,
    this.status,
  });
  leadsStatus.fromJson(Map<dynamic, dynamic> json) {
    id = json['lead_status_id'];
    lead_status = json['lead_status'];
    cts = ['cts'];
    status = ['status'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['lead_status_id'] = this.id;
    data['lead_status'] = this.lead_status;
    data['cts'] = this.cts;
    data['status'] = this.status;

    return data;
  }
}
