class PurchasePlanModel {
  final String? message;
  final int? planCustomerMappingId;
  final List<int>? bookingId;

  PurchasePlanModel({
    this.message,
    this.planCustomerMappingId,
    this.bookingId,
  });

  // Factory method to create an instance from a JSON map
  factory PurchasePlanModel.fromJson(Map<String, dynamic> json) {
    return PurchasePlanModel(
      message: json['message'] as String?,
      planCustomerMappingId: json['PlanCustomerMapping_id'] as int?,
      bookingId:
          (json['booking_id'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'PlanCustomerMapping_id': planCustomerMappingId,
      'booking_id': bookingId,
    };
  }
}
