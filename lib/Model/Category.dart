class category {
  String? name = null;
  int? id = null;
  String? description = null;
  var cts = null;

  var mts = null;
  var status;

  var untitle_id = null;

  category(
      {this.id,
      this.name,
      this.description,
      this.cts,
      this.mts,
      this.status,
      this.untitle_id});
  category.fromJson(Map<dynamic, dynamic> json) {
    id = json['category_id'];
    name = json['category_name'];
    description = json['description'];
    cts = ['cts'];
    mts = ['mts'];
    status = ['status'];
    untitle_id = ['untitled_id'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['category_id'] = this.id;
    data['category_name'] = this.name;
    data['description'] = this.description;
    data['cts'] = this.cts;
    data['mts'] = this.mts;
    data['status'] = this.status;
    data['untitled_id'] = this.untitle_id;

    return data;
  }
}
