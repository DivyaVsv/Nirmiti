class User_Registration {
  String? name = null;
  String? email = null;
  int? employee_id = null;
  String? password = null;
  var customer_id;
  //var branch;
  String? city = null;
  //var branch_id;
  //var state_id;
  //var state;
  String? phone = null;
  int? designation_id = null;
  String? designation_name = null;
  int? category = null;
  var token;

  User_Registration(
      {this.name,
      this.email,
      this.employee_id,
      this.password,
      //  this.branch,
      this.city,
      //  this.branch_id,
      this.customer_id,
      this.phone,
      //  this.state_id,
      //  this.state,
      this.designation_id,
      this.designation_name,
      this.category,
      this.token});
  User_Registration.fromJson(Map<dynamic, dynamic> json) {
    name = json['user_name'];
    employee_id = json['employee_id'];
    customer_id = json['customer_id'];
    //  branch = json['branch'];
    city = json['city'];
    //  branch_id = json['branch_id'];
    //  state_id = json['state_id'];
    //  state = json['state'];
    phone = json['mobile_number'];
    email = json['email_id'];
    password = json['password'];
    designation_id = json['designation_id'];
    designation_name = json['designation_name'];
    category = json['category'];
    token = json['token'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data['user_name'] = this.name;
    data['employee_id'] = this.employee_id;
    data['customer_id'] = this.customer_id;
    //  data['branch'] = this.branch;
    data['city'] = this.city;
    //  data['branch_id'] = this.branch_id;
    //  data['state_id'] = this.state_id;
    //  data['state'] = this.state;
    data['mobile_number'] = this.phone;
    data['email_id'] = this.email;
    data['password'] = this.password;
    data['designation_id'] = this.designation_id;
    data['designation_name'] = this.designation_name;
    data['category'] = this.category;
    data['token'] = this.token;

    return data;
  }
}
