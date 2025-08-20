// line_item_response.dart

import 'dart:convert';

LineItemResponse lineItemResponseFromJson(String str) =>
    LineItemResponse.fromJson(json.decode(str));

String lineItemResponseToJson(LineItemResponse data) =>
    json.encode(data.toJson());

class LineItemResponse {
  LineItemPagination? pagination;
  List<LineItemData>? data;

  LineItemResponse({
    this.pagination,
    this.data,
  });

  factory LineItemResponse.fromJson(Map<String, dynamic> json) =>
      LineItemResponse(
        pagination: json["pagination"] == null
            ? null
            : LineItemPagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? null
            : List<LineItemData>.from(
                json["data"].map((x) => LineItemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LineItemPagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  int? nextPage;
  int? previousPage;

  LineItemPagination({
    this.totalItems,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.from,
    this.to,
    this.nextPage,
    this.previousPage,
  });

  factory LineItemPagination.fromJson(Map<String, dynamic> json) =>
      LineItemPagination(
        totalItems: json["total_items"],
        perPage: json["per_page"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        from: json["from"],
        to: json["to"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_items": totalItems,
        "per_page": perPage,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "from": from,
        "to": to,
        "next_page": nextPage,
        "previous_page": previousPage,
      };
}

class LineItemData {
  int? id;
  int? categoryId;
  String? name;
  String? price;
  int? status;
  int? qty;
  dynamic deletedAt;

  LineItemData({
    this.id,
    this.categoryId,
    this.name,
    this.price,
    this.status,
    this.qty,
    this.deletedAt,
  });

  factory LineItemData.fromJson(Map<String, dynamic> json) => LineItemData(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        status: json["status"],
        qty: json["qty"] ?? 0,
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "status": status,
        "qty": qty,
        "deleted_at": deletedAt,
      };
}
