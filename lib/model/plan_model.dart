class PlanModel {
  Pagination? pagination;
  int? subscription;
  List<PlanData>? data;

  PlanModel({
    this.pagination,
    this.data,
    this.subscription,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<PlanData> dataList = list.map((i) => PlanData.fromJson(i)).toList();

    return PlanModel(
      pagination: Pagination.fromJson(json['pagination']),
      subscription: json['subscription'],
      data: dataList,
    );
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  int? nextPage;
  int? previousPage;

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

class PlanLimitation {
  String? limit;
  String? isChecked;

  PlanLimitation({
    this.limit,
    this.isChecked,
  });

  factory PlanLimitation.fromJson(Map<String, dynamic> json) {
    return PlanLimitation(
      limit: json['limit'],
      isChecked: json['is_checked'],
    );
  }
}

class PlanData {
  int? id;
  String? title;
  String? identifier;
  int? amount;
  String? duration;
  String? description;
  String? type;
  int? active;
  PlanLimitation? service;
  PlanLimitation? handyman;
  PlanLimitation? featuredService;

  PlanData({
    this.id,
    this.title,
    this.identifier,
    this.amount,
    this.duration,
    this.description,
    this.type,
    this.service,
    this.handyman,
    this.featuredService,
    this.active,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['id'],
      title: json['title'],
      identifier: json['identifier'],
      amount: json['amount'],
      duration: json['duration'],
      description: json['description'],
      type: json['type'],
      active: json['active'],
      service: json['plan_limitation'] != null &&
              json['plan_limitation']['service'] != null
          ? PlanLimitation.fromJson(json['plan_limitation']['service'])
          : null,
      handyman: json['plan_limitation'] != null &&
              json['plan_limitation']['handyman'] != null
          ? PlanLimitation.fromJson(json['plan_limitation']['handyman'])
          : null,
      featuredService: json['plan_limitation'] != null &&
              json['plan_limitation']['featured_service'] != null
          ? PlanLimitation.fromJson(json['plan_limitation']['featured_service'])
          : null,
    );
  }
}
