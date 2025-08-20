import 'package:homeowner/model/user_data_model.dart';

class LoginResponse {
  UserData? userData;
  bool? isUserExist;
  bool? status;
  String? message;

  LoginResponse({this.userData, this.isUserExist, this.status, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userData: json['data'] != null ? UserData.fromJson(json['data']) : null,
      isUserExist: json['is_user_exist'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    data['is_user_exist'] = isUserExist;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
