class BookingStatusResponse {
  int? id;
  String? value;
  String? label;
  int? status;
  int? sequence;
  String? createdAt;
  String? updatedAt;

  BookingStatusResponse({this.id, this.value, this.label, this.status, this.sequence, this.createdAt, this.updatedAt});

  BookingStatusResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    label = json['label'];
    status = json['status'];
    sequence = json['sequence'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['label'] = label;
    data['status'] = status;
    data['sequence'] = sequence;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
