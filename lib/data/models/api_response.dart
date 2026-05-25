class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;

  const ApiResponse({required this.status, required this.message, this.data});

  bool get isSuccess => status == 'success';

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> data) dataParser,
  ) {
    return ApiResponse<T>(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? dataParser(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse<T>(status: 'error', message: message);
  }
}
