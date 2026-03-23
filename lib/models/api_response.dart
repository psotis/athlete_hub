class ApiResponse<T> {
  final int status;
  final String message;
  final List<T> data;

  const ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final raw = json['data'] as List? ?? [];

    return ApiResponse<T>(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: raw.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
    );
  }

  T? get firstOrNull => data.isEmpty ? null : data.first;
}

class ApiResponseObject<T> {
  final int status;
  final String message;
  final T? data;

  const ApiResponseObject({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponseObject.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponseObject<T>(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
