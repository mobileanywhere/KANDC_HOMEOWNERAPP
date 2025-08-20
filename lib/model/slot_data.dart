class SlotData {
  String? day;
  List<String>? slot;

  SlotData({this.day, this.slot});

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      day: json['day'],
      slot: json['slot'] != null ? List<String>.from(json['slot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (slot != null) {
      data['slot'] = slot!.toSet().toList();
    }
    return data;
  }

  Map<String, dynamic> toJsonRequest() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (slot != null) {
      data['time'] = slot!.toSet().toList();
    }
    return data;
  }
}
