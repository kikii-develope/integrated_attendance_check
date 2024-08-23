class AttendanceCodeModel {
  final String date;
  final String code;

  AttendanceCodeModel({required this.code, required this.date});

  factory AttendanceCodeModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return switch (json) {
      {
        'date': String date,
        'code': String code,
      } =>
        AttendanceCodeModel(code: code, date: date),
      _ => throw const FormatException("출근코드 형식이 아닙니다."),
    };
  }
}
