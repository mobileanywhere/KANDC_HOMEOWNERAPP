class BookingAmountModel {
  num finalTotalServicePrice;
  num finalTotalTax;
  num finalSubTotal;
  num finalDiscountAmount;
  num finalCouponDiscountAmount;
  num finalGrandTotalAmount;

  BookingAmountModel({
    this.finalTotalServicePrice = 0,
    this.finalTotalTax = 0,
    this.finalSubTotal = 0,
    this.finalDiscountAmount = 0,
    this.finalCouponDiscountAmount = 0,
    this.finalGrandTotalAmount = 0,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['final_total_service_price'] = finalTotalServicePrice;
    data['final_total_tax'] = finalTotalTax;
    data['final_sub_total'] = finalSubTotal;
    data['final_discount_amount'] = finalDiscountAmount;
    data['final_coupon_discount_amount'] = finalCouponDiscountAmount;
    return data;
  }

  Map<String, dynamic> toBookingUpdateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['final_total_service_price'] = finalTotalServicePrice;
    data['final_total_tax'] = finalTotalTax;
    data['final_sub_total'] = finalSubTotal;
    data['final_discount_amount'] = finalDiscountAmount;
    data['final_coupon_discount_amount'] = finalCouponDiscountAmount;
    data['total_amount'] = finalGrandTotalAmount;
    return data;
  }
}
