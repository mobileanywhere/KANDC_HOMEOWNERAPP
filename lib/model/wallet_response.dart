class WalletResponse {
  num? balance;

  WalletResponse({this.balance});

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    return data;
  }
}
