import 'package:homeowner/model/package_data_model.dart';
import 'package:homeowner/model/pagination_model.dart';

class BlogResponse {
  Pagination? pagination;
  List<BlogData>? data;

  BlogResponse({this.pagination, this.data});

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      data: json["data"] != null ? (json['data'] as List).map((i) => BlogData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class BlogData {
  int? id;
  String? title;
  String? description;
  int? isFeatured;
  int? totalViews;
  int? authorId;
  String? authorName;
  String? authorImage;
  int? status;
  String? createdAt;
  List<String>? imageAttachments;
  List<Attachments>? attachment;
  String? deletedAt;

  BlogData({
    this.id,
    this.title,
    this.description,
    this.isFeatured,
    this.totalViews,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.status,
    this.imageAttachments,
    this.attachment,
    this.deletedAt,
    this.createdAt,
  });

  BlogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isFeatured = json['is_featured'];
    totalViews = json['total_views'];
    authorId = json['author_id'];
    authorName = json['author_name'];
    authorImage = json['author_image'];
    status = json['status'];
    imageAttachments = json['attchments'].cast<String>();
    if (json['attchments_array'] != null) {
      attachment = <Attachments>[];
      json['attchments_array'].forEach((v) {
        attachment!.add(Attachments.fromJson(v));
      });
    }
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['is_featured'] = isFeatured;
    data['total_views'] = totalViews;
    data['author_id'] = authorId;
    data['author_name'] = authorName;
    data['author_image'] = authorImage;
    data['status'] = status;
    data['attchments'] = imageAttachments;
    if (attachment != null) {
      data['attchments_array'] = attachment!.map((v) => v.toJson()).toList();
    }
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
