class PaginationModel {
  final int total;
  final int totalPages;
  final int currentPage;
  final int limit;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationModel({
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      currentPage: json['currentPage'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
    );
  }

  static const empty = PaginationModel(
    total: 0,
    totalPages: 1,
    currentPage: 1,
    limit: 10,
    hasNextPage: false,
    hasPrevPage: false,
  );
}
