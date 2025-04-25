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
      message: json['message'],
      data: json['data'] != null
          ? fromJsonT?.call(json['data']) ?? json['data']
          : null,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
