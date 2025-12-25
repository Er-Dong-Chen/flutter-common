import 'dart:convert';

class HttpResponse<T> {
  final int code;
  final String? message;
  final T? data;

  HttpResponse({
    required this.code,
    this.message,
    this.data,
  });

  factory HttpResponse.fromJson(Map<String, dynamic> json,
      {T Function(dynamic json)? fromJsonT}) {
    return HttpResponse(
      code: json['code'],
      message: json['message'] ?? json['msg'],
      data: json['data'] != null
          ? fromJsonT?.call(json['data']) ?? json['data']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
