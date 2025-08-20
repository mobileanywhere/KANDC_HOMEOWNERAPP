class Pagination {
  var currentPage;
  var totalPages;
  var totalItems;

  Pagination({this.currentPage, this.totalPages, this.totalItems});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['total_items'] = totalItems;
    return data;
  }
}
