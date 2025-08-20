import 'package:homeowner/model/service_detail_response.dart';

import 'extra_charges_model.dart';

class PaymentListResponse {
  List<PaymentData>? data;

  PaymentListResponse({this.data});

  PaymentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List).map((i) => PaymentData.fromJson(i)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentData {
  int? id;
  int? bookingId;
  int? customerId;
  num? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? customerName;
  int? quantity;
  CouponData? couponData;
  List<TaxData>? taxes;
  num? discount;
  num? price;
  List<ExtraChargesModel>? extraCharges;
  String? date;
  String? txnId;

  PaymentData({
    this.id,
    this.bookingId,
    this.customerId,
    this.totalAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.customerName,
    this.quantity,
    this.couponData,
    this.taxes,
    this.discount,
    this.price,
    this.extraCharges,
    this.date,
    this.txnId,
  });

  PaymentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    customerId = json['customer_id'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    customerName = json['customer_name'];
    quantity = json['quantity'];
    taxes = json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null;
    couponData = json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null;
    discount = json['discount'];
    price = json['price'];
    date = json['date'];
    txnId = json['txn_id'];
    extraCharges = json['extra_charges'] != null ? (json['extra_charges'] as List).map((i) => ExtraChargesModel.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['customer_id'] = customerId;
    data['total_amount'] = totalAmount;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['customer_name'] = customerName;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['price'] = price;
    data['date'] = date;
    data['txn_id'] = txnId;
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (couponData != null) {
      data['coupon_data'] = couponData!.toJson();
    }
    if (extraCharges != null) {
      data['extra_charges'] = extraCharges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
