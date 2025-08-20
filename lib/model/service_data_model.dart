import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/slot_data.dart';
import 'package:homeowner/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

class ServiceData {
  int? id;
  int? categoryId;
  int? providerId;
  int? cityId;
  int? status;
  int? isFeatured;
  int? bookingAddressId;
  num? price;
  num? discount;
  num? totalReview;
  num? totalRating;
  num? isFavourite;
  num? isSlot;
  num? serviceId;
  num? userId;
  String? duration;
  String? description;
  String? providerName;
  String? categoryName;
  String? subCategoryName;
  String? providerImage;
  String? name;
  String? type;
  String? createdAt;
  String? customerName;
  String? bookingDate;
  String? bookingDay;
  String? bookingSlot;
  String? dateTimeVal;
  String? bookingDescription;
  String? address;
  num? isEnableAdvancePayment;
  num? advancePaymentPercentage;
  num? advancePaymentAmount;
  List<String>? attachments;
  List<String>? serviceAttachments;
  List<ServiceAddressMapping>? serviceAddressMapping;
  List<SlotData>? bookingSlots;
  List<BookingPackage>? servicePackage;

  //Local
  bool get isSlotAvailable => isSlot.validate() == 1;

  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isFixedService => type.validate() == SERVICE_TYPE_FIXED;

  bool get isFreeService => price.validate() == 0;

  bool get isAdvancePayment => isEnableAdvancePayment.validate() == 1 && getBoolAsync(IS_ADVANCE_PAYMENT_ALLOWED) && servicePackage.validate().isEmpty;

  ServiceData({
    this.attachments,
    this.bookingDate,
    this.bookingSlot,
    this.categoryId,
    this.categoryName,
    this.cityId,
    this.description,
    this.bookingDay,
    this.discount,
    this.duration,
    this.isSlot,
    this.id,
    this.bookingSlots,
    this.isFeatured,
    this.name,
    this.price,
    this.providerId,
    this.providerName,
    this.status,
    this.totalRating,
    this.totalReview,
    this.providerImage,
    this.type,
    this.isFavourite,
    this.serviceAddressMapping,
    this.subCategoryName,
    this.createdAt,
    this.customerName,
    this.serviceAttachments,
    this.serviceId,
    this.userId,
    this.dateTimeVal,
    this.bookingAddressId,
    this.servicePackage,
    this.isEnableAdvancePayment,
    this.advancePaymentPercentage,
    this.advancePaymentAmount,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      providerId: json['provider_id'],
      price: json['price'],
      type: json['type'],
      bookingDate: json['booking_date'],
      bookingSlot: json['booking_slot'],
      bookingDay: json['booking_day'],
      isSlot: json['is_slot'],
      subCategoryName: json['subcategory_name'],
      discount: json['discount'],
      duration: json['duration'],
      status: json['status'],
      description: json['description'],
      isFeatured: json['is_featured'],
      providerName: json['provider_name'],
      categoryName: json['category_name'],
      attachments: json['attchments'] != null ? List<String>.from(json['attchments']) : null,
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      isFavourite: json['is_favourite'],
      cityId: json['city_id'],
      providerImage: json['provider_image'],
      serviceAddressMapping: json['service_address_mapping'] != null ? (json['service_address_mapping'] as List).map((i) => ServiceAddressMapping.fromJson(i)).toList() : null,
      bookingSlots: json['slots'] != null ? (json['slots'] as List).map((i) => SlotData.fromJson(i)).toList() : null,
      createdAt: json['created_at'],
      customerName: json['customer_name'],
      serviceAttachments: json['service_attchments'] != null ? List<String>.from(json['service_attchments']) : null,
      serviceId: json['service_id'],
      userId: json['user_id'],
      servicePackage: json['servicePackage'] != null ? (json['servicePackage'] as List).map((i) => BookingPackage.fromJson(i)).toList() : null,
      isEnableAdvancePayment: json[AdvancePaymentKey.isEnableAdvancePayment],
      advancePaymentPercentage: json[AdvancePaymentKey.advancePaymentAmount],
      advancePaymentAmount: json['advance_payment_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['city_id'] = cityId;
    data['description'] = description;
    data['discount'] = discount;
    data['booking_date'] = bookingDate;
    data['booking_slot'] = bookingSlot;
    data['booking_day'] = bookingDay;
    data['slots'] = bookingSlots;
    data['duration'] = duration;
    data['id'] = id;
    data['is_featured'] = isFeatured;
    data['name'] = name;
    data['price'] = price;
    data['is_slot'] = isSlot;
    // data['price_format'] = this.priceFormat;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['status'] = status;
    data['total_rating'] = totalRating;
    data['total_review'] = totalReview;
    data['provider_image'] = providerImage;
    data['subcategory_name'] = subCategoryName;
    data['created_at'] = createdAt;
    data['customer_name'] = customerName;
    data['service_id'] = serviceId;
    data['user_id'] = userId;
    data['type'] = type;
    if (serviceAttachments != null) {
      data['service_attchments'] = serviceAttachments;
    }
    if (attachments != null) {
      data['attchments'] = attachments;
    }
    data['is_favourite'] = isFavourite;
    if (serviceAddressMapping != null) {
      data['service_address_mapping'] = serviceAddressMapping!.map((v) => v.toJson()).toList();
    }

    if (servicePackage != null) {
      data['servicePackage'] = servicePackage!.map((v) => v.toJson()).toList();
    }
    data[AdvancePaymentKey.isEnableAdvancePayment] = isAdvancePayment;
    data[AdvancePaymentKey.advancePaymentAmount] = advancePaymentPercentage;
    data['advance_payment_amount'] = advancePaymentAmount;
    return data;
  }
}

class ServiceAddressMapping {
  int? id;
  int? serviceId;
  int? providerAddressId;
  String? createdAt;
  String? updatedAt;
  ProviderAddressMapping? providerAddressMapping;

  ServiceAddressMapping({this.id, this.serviceId, this.providerAddressId, this.createdAt, this.updatedAt, this.providerAddressMapping});

  ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    providerAddressId = json['provider_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    providerAddressMapping = json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_id'] = serviceId;
    data['provider_address_id'] = providerAddressId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (providerAddressMapping != null) {
      data['provider_address_mapping'] = providerAddressMapping!.toJson();
    }
    return data;
  }
}

class ProviderAddressMapping {
  int? id;
  int? providerId;
  String? address;
  String? latitude;
  String? longitude;
  var status;
  String? createdAt;
  String? updatedAt;

  ProviderAddressMapping({this.id, this.providerId, this.address, this.latitude, this.longitude, this.status, this.createdAt, this.updatedAt});

  ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}