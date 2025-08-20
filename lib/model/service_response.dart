import 'package:homeowner/model/service_data_model.dart';

import 'pagination_model.dart';

class ServiceResponse {
  List<ServiceData>? serviceList;
  Pagination? pagination;
  int? max;
  int? min;
  List<ServiceData>? userServices;

  ServiceResponse({this.serviceList, this.pagination, this.max, this.min, this.userServices});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      serviceList: json['data'] != null ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      max: json['max'],
      min: json['min'],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      userServices: json['user_services'] != null ? (json['user_services'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['max'] = max;
    data['min'] = min;
    if (serviceList != null) {
      data['data'] = serviceList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (userServices != null) {
      data['user_services'] = userServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
