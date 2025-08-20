import 'package:homeowner/model/service_data_model.dart';
import 'package:homeowner/model/user_data_model.dart';

class ServiceDetailResponse {
  List<CouponData>? couponData;
  UserData? provider;
  List<RatingData>? ratingData;
  ServiceData? serviceDetail;
  List<TaxData>? taxes;
  List<ServiceData>? relatedService;
  List<ServiceFaq>? serviceFaq;

  ServiceDetailResponse({this.couponData, this.provider, this.ratingData, this.serviceDetail, this.taxes, this.relatedService, this.serviceFaq});

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      couponData: json['coupon_data'] != null ? (json['coupon_data'] as List).map((i) => CouponData.fromJson(i)).toList() : null,
      provider: json['provider'] != null ? UserData.fromJson(json['provider']) : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      serviceDetail: json['service_detail'] != null ? ServiceData.fromJson(json['service_detail']) : null,
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      relatedService: json['related_service'] != null ? (json['related_service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      serviceFaq: json['service_faq'] != null ? (json['service_faq'] as List).map((i) => ServiceFaq.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (couponData != null) {
      data['coupon_data'] = couponData!.map((v) => v.toJson()).toList();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (ratingData != null) {
      data['rating_data'] = ratingData!.map((v) => v.toJson()).toList();
    }
    if (serviceDetail != null) {
      data['service_detail'] = serviceDetail!.toJson();
    }
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (relatedService != null) {
      data['related_service'] = relatedService!.map((v) => v.toJson()).toList();
    }
    if (serviceFaq != null) {
      data['service_faq'] = serviceFaq!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxData {
  int? id;
  int? providerId;
  String? title;
  String? type;
  num? value;
  num? totalCalculatedValue;

  TaxData({this.id, this.providerId, this.title, this.type, this.value, this.totalCalculatedValue});

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      providerId: json['provider_id'],
      title: json['title'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['title'] = title;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class CouponData {
  String? code;
  num? discount;
  String? discountType;
  String? expireDate;
  int? id;
  int? status;

  CouponData({this.code, this.discount, this.discountType, this.expireDate, this.id, this.status});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      code: json['code'],
      discount: json['discount'],
      discountType: json['discount_type'],
      expireDate: json['expire_date'],
      id: json['id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['expire_date'] = expireDate;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}

class RatingData {
  int? bookingId;
  String? createdAt;
  int? id;
  String? profileImage;
  num? rating;
  int? customerId;
  String? review;
  int? serviceId;
  String? updatedAt;

  int? handymanId;
  String? handymanName;
  String? handymanProfileImage;
  String? customerName;
  String? customerProfileImage;
  String? serviceName;
  List<String>? attachments;

  RatingData({
    this.bookingId,
    this.createdAt,
    this.id,
    this.profileImage,
    this.rating,
    this.customerId,
    this.review,
    this.serviceId,
    this.updatedAt,
    this.handymanId,
    this.handymanName,
    this.handymanProfileImage,
    this.customerName,
    this.customerProfileImage,
    this.serviceName,
    this.attachments,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      updatedAt: json['updated_at'],
      bookingId: json['booking_id'],
      createdAt: json['created_at'],
      id: json['id'],
      profileImage: json['profile_image'],
      rating: json['rating'],
      customerId: json['customer_id'],
      review: json['review'],
      serviceId: json['service_id'],
      handymanId: json['handyman_id'],
      handymanName: json['handyman_name'],
      handymanProfileImage: json['handyman_profile_image'],
      customerName: json['customer_name'],
      customerProfileImage: json['customer_profile_image'],
      serviceName: json['service_name'],
      attachments: json['attchments'] != null ? List<String>.from(json['attchments']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updated_at'] = updatedAt;
    data['booking_id'] = bookingId;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['profile_image'] = profileImage;
    data['customer_id'] = customerId;
    data['rating'] = rating;
    data['review'] = review;
    data['service_id'] = serviceId;
    data['handyman_id'] = handymanId;
    data['handyman_name'] = handymanName;
    data['handyman_profile_image'] = handymanProfileImage;
    data['customer_name'] = customerName;
    data['customer_profile_image'] = customerProfileImage;
    data['service_name'] = serviceName;
    if (attachments != null) {
      data['attchments'] = attachments;
    }
    return data;
  }
}

class ServiceFaq {
  String? createdAt;
  String? description;
  int? id;
  int? serviceId;
  int? status;
  String? title;
  String? updatedAt;

  ServiceFaq({this.createdAt, this.description, this.id, this.serviceId, this.status, this.title, this.updatedAt});

  factory ServiceFaq.fromJson(Map<String, dynamic> json) {
    return ServiceFaq(
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      serviceId: json['service_id'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['description'] = description;
    data['id'] = id;
    data['service_id'] = serviceId;
    data['status'] = status;
    data['title'] = title;
    data['updated_at'] = updatedAt;
    return data;
  }
}
