class CityListResponse {
  int? id;
  String? name;
  int? stateId;

  CityListResponse({this.id, this.name, this.stateId});

  factory CityListResponse.fromJson(Map<String, dynamic> json) {
    return CityListResponse(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state_id'] = stateId;
    return data;
  }
}
