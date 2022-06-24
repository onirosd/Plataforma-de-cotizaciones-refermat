import 'dart:convert';

class ResponseError {
  String description;
  int error;
  int success;

  ResponseError({
    required this.description,
    required this.error,
    required this.success,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'error': error,
      'success': success,
    };
  }

  factory ResponseError.fromMap(Map<String, dynamic> map) {
    return ResponseError(
      description: map['description'],
      error: map['error'],
      success: map['success'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseError.fromJson(String source) =>
      ResponseError.fromMap(json.decode(source));
}
