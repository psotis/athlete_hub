class ApiError {
  final int status;
  final String message;

  const ApiError({required this.status, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      status: (json['status'] as num?)?.toInt() ?? 500,
      message: json['message'] as String? ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message};

  @override
  String toString() => 'ApiError(status: $status, message: $message)';
}
