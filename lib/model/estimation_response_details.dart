import 'dart:convert';
// Status = 0 ,1 ,2,3
// 0=> pending
// 1=> mail sent
// 2=> approved
// 3 => decline

class EstimationDetailsResponse {
  final String? message;
  final List<EstimationLineItemData>? lineitemData;
  final Estimation? estimation;

  EstimationDetailsResponse({
    required this.message,
    this.lineitemData,
    this.estimation,
  });

  factory EstimationDetailsResponse.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return EstimationDetailsResponse(
      message: json['message'],
      lineitemData: json['lineitem_data'] != null
          ? List<EstimationLineItemData>.from(json['lineitem_data']
              .map((data) => EstimationLineItemData.fromJson(data)))
          : null,
      estimation: json['estimation'] != null
          ? Estimation.fromJson(json['estimation'])
          : null,
    );
  }
}

class EstimationLineItemData {
  final int? customerId;
  final int? bookingId;
  final int? lineItemId;
  final String? lineItemName;
  final int? lineItemQty;
  final String? lineItemPrice;
  final int? subTotal;

  EstimationLineItemData({
    required this.customerId,
    required this.bookingId,
    required this.lineItemId,
    required this.lineItemName,
    required this.lineItemQty,
    required this.lineItemPrice,
    required this.subTotal,
  });

  factory EstimationLineItemData.fromJson(Map<String, dynamic> json) {
    return EstimationLineItemData(
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

class Estimation {
  final int? id;
  final int? customerId;
  final int? bookingId;
  final int? serviceId;
  final int? createdBy;
  final dynamic approvedBy;
  final String? totalAmount;
  final int? status;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Estimation({
    required this.id,
    required this.customerId,
    required this.bookingId,
    required this.serviceId,
    required this.createdBy,
    required this.approvedBy,
    required this.totalAmount,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Estimation.fromJson(Map<String, dynamic> json) {
    return Estimation(
      id: json['id'],
      customerId: json['customer_id'],
      bookingId: json['booking_id'],
      serviceId: json['service_id'],
      createdBy: json['created_by'],
      approvedBy: json['approved_by'],
      totalAmount: json['total_amount'],
      status: json['status'],
      deletedAt: json['deleted_at'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
