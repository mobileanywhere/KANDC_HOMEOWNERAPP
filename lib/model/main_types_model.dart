class Pagination {
  final int? totalItems;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;
  final int? from;
  final int? to;
  final dynamic nextPage;
  final dynamic previousPage;

  Pagination({
    this.totalItems,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.from,
    this.to,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['total_items'],
      perPage: json['per_page'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      from: json['from'],
      to: json['to'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class MainTypesData {
  final int? id;
  final int? parentId;
  final String? name;
  final int? status;
  final bool? isExist;
  final String? typeImage;
  final dynamic deletedAt;

  MainTypesData({
    this.id,
    this.parentId,
    this.name,
    this.status,
    this.isExist,
    this.typeImage,
    this.deletedAt,
  });

  factory MainTypesData.fromJson(Map<String, dynamic> json) {
    return MainTypesData(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      status: json['status'],
      isExist: json['is_exist'] ?? false,
      typeImage: json['type_image'],
      deletedAt: json['deleted_at'],
    );
  }
}

class MainTypesModel {
  final Pagination? pagination;
  final List<MainTypesData>? data;

  MainTypesModel({
    this.pagination,
    this.data,
  });

  factory MainTypesModel.fromJson(Map<String, dynamic> json) {
    return MainTypesModel(
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? List<MainTypesData>.from(
              json['data'].map((data) => MainTypesData.fromJson(data)))
          : null,
    );
  }
}
