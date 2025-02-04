
import 'package:attendance_check/helpers/response_model.dart';

import 'package:http/http.dart' as http;

Future<String> getCurrentAttendanceCode (String baseUri) async {
    String requestUri = '$baseUri/attendance/employee/code';

    http.Response res = await http.get(Uri.parse(requestUri));
    ResponseModel<String> parsedRes = ResponseModel.fromJson(res.body);

    return parsedRes.object;
}