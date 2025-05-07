class PropertyModel {
  List<PropertyData>? data;

  PropertyModel({this.data});

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      data: json['data'] != null
          ? List<PropertyData>.from(json['data'].map((propertyData) =>
              PropertyData.fromJson(propertyData as Map<String, dynamic>)))
          : null,
    );
  }
}

class PropertyData {
  int? id;
  int? userId;
  String? name;
  String? address;
  String? size;
  int? stateId;
  int? cityId;
  String? zipCode;
  String? bedrooms;
  String? levels;
  int? pool;
  String? gateCode;
  int? isDogs;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int? isSubscription;
  SubscriptionData? subscriptionData;

  PropertyData({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.size,
    this.stateId,
    this.cityId,
    this.zipCode,
    this.bedrooms,
    this.levels,
    this.pool,
    this.gateCode,
    this.isDogs,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSubscription,
    this.subscriptionData,
  });

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    return PropertyData(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      address: json['address'],
      size: json['size'],
      stateId: json['state_id'],
      cityId: json['city_id'],
      zipCode: json['zip_code'],
      bedrooms: json['bedrooms'],
      levels: json['levels'],
      pool: json['pool'],
      gateCode: json['gate_code'],
      isDogs: json['is_dogs'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      isSubscription: json['is_subscription'],
      subscriptionData: json['subscription_data'] is Map
          ? SubscriptionData.fromJson(json['subscription_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'size': size,
      'state_id': stateId,
      'city_id': cityId,
      'zip_code': zipCode,
      'bedrooms': bedrooms,
      'levels': levels,
      'pool': pool,
      'gate_code': gateCode,
      'is_dogs': isDogs,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'is_subscription': isSubscription,
      'subscription_data': subscriptionData?.toJson(),
    };
  }
}

class SubscriptionData {
  int? id;
  String? title;
  String? identifier;
  int? amount;
  String? duration;
  String? description;
  String? type;
  int? active;

  SubscriptionData({
    this.id,
    this.title,
    this.identifier,
    this.amount,
    this.duration,
    this.description,
    this.type,
    this.active,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json['id'],
      title: json['title'],
      identifier: json['identifier'],
      amount: json['amount'],
      duration: json['duration'],
      description: json['description'],
      type: json['type'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'identifier': identifier,
      'amount': amount,
      'duration': duration,
      'description': description,
      'type': type,
      'active': active,
    };
  }
}
