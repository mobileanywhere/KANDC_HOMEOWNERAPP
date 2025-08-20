import 'dart:convert';

import 'package:homeowner/model/country_list_model.dart';

class ConfigurationResponse {
  List<Configuration>? configurations;
  List<PaymentSetting>? paymentSettings;

  ConfigurationResponse({
    this.configurations,
    this.paymentSettings,
  });

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return ConfigurationResponse(
      configurations: json['configurations'] != null ? (json['configurations'] as List).map((i) => Configuration.fromJson(i)).toList() : null,
      paymentSettings: json['payment_settings'] != null ? (json['payment_settings'] as List).map((i) => PaymentSetting.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (configurations != null) {
      data['configurations'] = configurations!.map((v) => v.toJson()).toList();
    }
    if (paymentSettings != null) {
      data['payment_settings'] = paymentSettings!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Configuration {
  CountryListResponse? country;
  int? id;
  String? key;
  String? type;
  String? value;

  Configuration({this.country, this.id, this.key, this.type, this.value});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      country: json['country'] != null ? CountryListResponse.fromJson(json['country']) : null,
      id: json['id'],
      key: json['key'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['type'] = type;
    data['value'] = value;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    return data;
  }
}

class PaymentSetting {
  int? id;
  int? isTest;
  LiveValue? liveValue;
  int? status;
  String? title;
  String? type;
  LiveValue? testValue;

  PaymentSetting({this.id, this.isTest, this.liveValue, this.status, this.title, this.type, this.testValue});

  static String encode(List<PaymentSetting> paymentList) {
    return json.encode(paymentList.map<Map<String, dynamic>>((payment) => payment.toJson()).toList());
  }

  static List<PaymentSetting> decode(String musics) {
    return (json.decode(musics) as List<dynamic>).map<PaymentSetting>((item) => PaymentSetting.fromJson(item)).toList();
  }

  factory PaymentSetting.fromJson(Map<String, dynamic> json) {
    return PaymentSetting(
      id: json['id'],
      isTest: json['is_test'],
      liveValue: json['live_value'] != null ? LiveValue.fromJson(json['live_value']) : null,
      status: json['status'],
      title: json['title'],
      type: json['type'],
      testValue: json['value'] != null ? LiveValue.fromJson(json['value']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_test'] = isTest;
    data['status'] = status;
    data['title'] = title;
    data['type'] = type;
    if (liveValue != null) {
      data['live_value'] = liveValue?.toJson();
    }
    if (testValue != null) {
      data['value'] = testValue?.toJson();
    }
    return data;
  }
}

class LiveValue {
  /// For Stripe
  String? stripeUrl;
  String? stripeKey;
  String? stripePublickey;

  /// For Razor Pay
  String? razorUrl;
  String? razorKey;
  String? razorSecret;

  /// For Flutter Wave
  String? flutterwavePublic;
  String? flutterwaveSecret;
  String? flutterwaveEncryption;

  /// For PayStack
  String? paypalUrl;

  /// For Sadad
  String? sadadId;
  String? sadadKey;
  String? sadadDomain;

  /// For CinetPay
  String? cinetId;
  String? cinetKey;
  String? cinetPublicKey;

  LiveValue({
    this.stripeUrl,
    this.stripeKey,
    this.stripePublickey,
    this.razorUrl,
    this.razorKey,
    this.razorSecret,
    this.flutterwavePublic,
    this.flutterwaveSecret,
    this.flutterwaveEncryption,
    this.paypalUrl,
    this.sadadId,
    this.sadadKey,
    this.sadadDomain,
    this.cinetId,
    this.cinetKey,
    this.cinetPublicKey,
  });

  factory LiveValue.fromJson(Map<String, dynamic> json) {
    return LiveValue(
      stripeUrl: json['stripe_url'],
      stripeKey: json['stripe_key'],
      stripePublickey: json['stripe_publickey'],
      razorUrl: json['razor_url'],
      razorKey: json['razor_key'],
      razorSecret: json['razor_secret'],
      flutterwavePublic: json['flutterwave_public'],
      flutterwaveSecret: json['flutterwave_secret'],
      flutterwaveEncryption: json['flutterwave_encryption'],
      paypalUrl: json['paypal_url'],
      sadadId: json['sadad_id'],
      sadadKey: json['sadad_key'],
      sadadDomain: json['sadad_domain'],
      cinetId: json['cinet_id'],
      cinetKey: json['cinet_key'],
      cinetPublicKey: json['cinet_publickey'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stripe_url'] = stripeUrl;
    data['stripe_key'] = stripeKey;
    data['stripe_publickey'] = stripePublickey;
    data['razor_url'] = razorUrl;
    data['razor_key'] = razorKey;
    data['razor_secret'] = razorSecret;
    data['flutterwave_public'] = flutterwavePublic;
    data['flutterwave_secret'] = flutterwaveSecret;
    data['flutterwave_encryption'] = flutterwaveEncryption;
    data['paypal_url'] = paypalUrl;
    data['sadad_id'] = sadadId;
    data['sadad_key'] = sadadKey;
    data['sadad_domain'] = sadadDomain;
    data['cinet_id'] = cinetId;
    data['cinet_key'] = cinetKey;
    data['cinet_publickey'] = cinetPublicKey;

    return data;
  }
}
