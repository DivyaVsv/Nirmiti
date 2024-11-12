class SuperResponse<T> {
  int? status = null;
  String? message = null;
  String? title = null;
  var expiredTime;
  T data;

  SuperResponse(
      {this.status,
      this.message,
      this.title,
      this.expiredTime,
      required this.data});

  factory SuperResponse.fromJson(Map<dynamic, dynamic> json, T t) {
    return SuperResponse<T>(
        status: json['status'],
        message: json['msg'],
        title: json['token'],
        expiredTime: json['expiresIn'],
        data: t);
  }
}
