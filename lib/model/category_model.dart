import 'package:homeowner/model/pagination_model.dart';

class CategoryResponse {
  List<CategoryData>? categoryList;
  Pagination? pagination;

  CategoryResponse({this.categoryList, this.pagination});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      categoryList: json['data'] != null
          ? (json['data'] as List).map((i) => CategoryData.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categoryList != null) {
      data['data'] = categoryList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class CategoryData {
  String? categoryImage;
  String? color;
  String? description;
  int? id;
  int? isFeatured;
  bool? isExist;
  String? name;
  int? status;
  bool isSelected;
  int? services;

  CategoryData(
      {this.categoryImage,
      this.color,
      this.description,
      this.id,
      this.isFeatured,
      this.isExist,
      this.name,
      this.status,
      this.isSelected = false,
      this.services});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryImage: json['category_image'],
      color: json['color'],
      description: json['description'],
      id: json['id'],
      isFeatured: json['is_featured'],
      isExist: json['is_exist'] ?? false,
      name: json['name'],
      status: json['status'],
      services: json['services'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_image'] = categoryImage;
    data['color'] = color;
    data['description'] = description;
    data['id'] = id;
    data['is_featured'] = isFeatured;
    data['is_exist'] = isExist;
    data['name'] = name;
    data['status'] = status;
    data['services'] = services;
    return data;
  }
}
