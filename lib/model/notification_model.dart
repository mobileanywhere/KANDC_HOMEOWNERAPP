class NotificationListResponse {
  List<NotificationData>? notificationData;
  int? allUnreadCount;

  NotificationListResponse({this.notificationData, this.allUnreadCount});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = [];
      json['notification_data'].forEach((v) {
        notificationData!.add(NotificationData.fromJson(v));
      });
    }
    allUnreadCount = json['all_unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notificationData != null) {
      data['notification_data'] = notificationData!.map((v) => v.toJson()).toList();
    }
    data['all_unread_count'] = allUnreadCount;
    return data;
  }
}

class NotificationData {
  String? id;
  String? readAt;
  String? createdAt;
  String? profileImage;
  NotificationInnerData? data;

  NotificationData({this.id, this.readAt, this.createdAt, this.data});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    profileImage = json['profile_image'];
    data = json['data'] != null ? NotificationInnerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['profile_image'] = profileImage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationInnerData {
  int? id;
  String? type;
  String? subject;
  String? message;
  String? notificationType;

  NotificationInnerData({this.id, this.type, this.subject, this.message, this.notificationType});

  NotificationInnerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    subject = json['subject'];
    message = json['message'];
    notificationType = json['notification-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['subject'] = subject;
    data['message'] = message;
    data['notification-type'] = notificationType;
    return data;
  }
}
