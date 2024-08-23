import 'dart:convert';

class ResponseModel {
  int status;
  Map<String, dynamic> object;
  String message;

  ResponseModel(
      {required this.status, required this.object, required this.message});

  factory ResponseModel.fromJson(String body) {
    Map<String, dynamic> parsedJson = jsonDecode(body);

    return ResponseModel(
        status: parsedJson['status'],
        message: parsedJson['message'],
        object: parsedJson['object']);
  }
}
