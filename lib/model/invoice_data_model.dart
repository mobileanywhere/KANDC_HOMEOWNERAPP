import 'package:homeowner/model/booking_data_model.dart';

class InvoiceDataModel {
  String? message;
  List<InvoiceLineItemData>? lineitemData;
  InvoiceBookingData? bookingData;

  InvoiceDataModel({this.message, this.lineitemData, this.bookingData});

  factory InvoiceDataModel.fromJson(Map<String, dynamic> json) {
    return InvoiceDataModel(
      message: json['message'],
      lineitemData: json['lineitem_data'] != null
          ? (json['lineitem_data'] as List)
              .map((item) => InvoiceLineItemData.fromJson(item))
              .toList()
          : null,
      bookingData: json['booking_data'] != null
          ? InvoiceBookingData.fromJson(json['booking_data'])
          : null,
    );
  }
}

class InvoiceLineItemData {
  int? customerId;
  int? bookingId;
  int? lineItemId;
  String? lineItemName;
  int? lineItemQty;
  String? lineItemPrice;
  int? subTotal;

  InvoiceLineItemData({
    this.customerId,
    this.bookingId,
    this.lineItemId,
    this.lineItemName,
    this.lineItemQty,
    this.lineItemPrice,
    this.subTotal,
  });

  factory InvoiceLineItemData.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItemData(
      customerId: json['customer_id'],
      bookingId: json['booking_id'],
      lineItemId: json['line_item_id'],
      lineItemName: json['line_item_name'],
      lineItemQty: json['line_item_qty'],
      lineItemPrice: json['line_item_price'],
      subTotal: json['sub_total'],
    );
  }
}

class InvoiceBookingData {
  int? customerId;
  BookingData? booking;
  Payment? payment;
  Service? service;

  InvoiceBookingData({
    this.customerId,
    this.booking,
    this.payment,
    this.service,
  });

  factory InvoiceBookingData.fromJson(Map<String, dynamic> json) {
    return InvoiceBookingData(
      customerId: json['customer_id'],
      booking:
          json['booking'] != null ? BookingData.fromJson(json['booking']) : null,
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      service:
          json['service'] != null ? Service.fromJson(json['service']) : null,
    );
  }
}

class Service {
  int? id;
  String? name;
  int? categoryId;
  int? providerId;
  int? price;
  String? type;
  String? duration;
  int? discount;
  int? status;
  String? description;
  int? isFeatured;
  int? addedBy;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? subcategoryId;
  String? serviceType;
  int? isSlot;
  int? isEnableAdvancePayment;
  double? advancePaymentAmount;

  Service({
    this.id,
    this.name,
    this.categoryId,
    this.providerId,
    this.price,
    this.type,
    this.duration,
    this.discount,
    this.status,
    this.description,
    this.isFeatured,
    this.addedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.subcategoryId,
    this.serviceType,
    this.isSlot,
    this.isEnableAdvancePayment,
    this.advancePaymentAmount,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      providerId: json['provider_id'],
      price: json['price'],
      type: json['type'],
      duration: json['duration'],
      discount: json['discount'],
      status: json['status'],
      description: json['description'],
      isFeatured: json['is_featured'],
      addedBy: json['added_by'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subcategoryId: json['subcategory_id'],
      serviceType: json['service_type'],
      isSlot: json['is_slot'],
      isEnableAdvancePayment: json['is_enable_advance_payment'],
      advancePaymentAmount: json['advance_payment_amount'],
    );
  }
}

class Payment {
  int? id;
  int? customerId;
  int? bookingId;
  String? datetime;
  int? discount;
  double? totalAmount;
  String? paymentType;
  String? txnId;
  String? paymentStatus;
  dynamic otherTransactionDetail;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Payment({
    this.id,
    this.customerId,
    this.bookingId,
    this.datetime,
    this.discount,
    this.totalAmount,
    this.paymentType,
    this.txnId,
    this.paymentStatus,
    this.otherTransactionDetail,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      customerId: json['customer_id'],
      bookingId: json['booking_id'],
      datetime: json['datetime'],
      discount: json['discount'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentType: json['payment_type'],
      txnId: json['txn_id'],
      paymentStatus: json['payment_status'],
      otherTransactionDetail: json['other_transaction_detail'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
