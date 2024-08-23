import 'dart:convert';

import 'package:attendance_check/helpers/response_model.dart';

import 'attendance_code_model.dart';
import 'package:http/http.dart' as http;

Future<AttendanceCodeModel> getCurrentAttendanceCode (String baseUri) async {
    String requestUri = '$baseUri/attendance/code';

    http.Response res = await http.get(Uri.parse(requestUri));
    ResponseModel parsedRes = ResponseModel.fromJson(res.body);
    return AttendanceCodeModel.fromJson(parsedRes.object);
}