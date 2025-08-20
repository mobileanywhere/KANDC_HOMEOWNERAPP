import 'package:homeowner/model/service_detail_response.dart';
import 'package:homeowner/model/user_data_model.dart';

import 'service_data_model.dart';

class ProviderInfoResponse {
  UserData? userData;
  List<ServiceData>? serviceList;
  List<RatingData>? handymanRatingReviewList;

  ProviderInfoResponse({this.userData, this.serviceList, this.handymanRatingReviewList});

  ProviderInfoResponse.fromJson(Map<String, dynamic> json) {
    userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      serviceList = [];
      json['service'].forEach((v) {
        serviceList!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReviewList = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReviewList!.add(RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['data'] = userData!.toJson();
    }
    if (serviceList != null) {
      data['service'] = serviceList!.map((v) => v.toJson()).toList();
    }
    if (handymanRatingReviewList != null) {
      data['handyman_rating_review'] = handymanRatingReviewList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
